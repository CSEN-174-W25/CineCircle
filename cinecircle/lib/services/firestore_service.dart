import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
Future<void> saveReview({
  required Media reviewedMedia,
  required Rating userReview,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final mediaRef = FirebaseFirestore.instance.collection('media').doc(reviewedMedia.id.toString());
  final reviewRef = mediaRef.collection('reviews').doc(user.uid); // Check id so each user can have one review per movie

  // Ensure the media document exists before adding a review
  final mediaSnapshot = await mediaRef.get();
  if (!mediaSnapshot.exists) {
    await mediaRef.set(reviewedMedia.toFirestore());
  }

  // Save the review in `reviews` subcollection
  await reviewRef.set({
    'userId': user.uid, // 🔹 Ensures reviews are linked to users
    'username': userReview.username,
    'review': userReview.review,
    'score': userReview.score,
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Recalculate user's total average rating
  final userReviewsSnapshot = await FirebaseFirestore.instance
      .collectionGroup('reviews')
      .where('userId', isEqualTo: user.uid)
      .get();

  double totalUserRating = 0;
  int userReviewCount = userReviewsSnapshot.docs.length;

  for (var doc in userReviewsSnapshot.docs) {
    totalUserRating += (doc['score'] as num).toDouble();
  }

  double newUserAvgRating = userReviewCount > 0 ? totalUserRating / userReviewCount : 0.0;

  // Update user's reviewed list to contain mediaId
  await userRef.update({
    'reviewedMedias': FieldValue.arrayUnion([reviewedMedia.id.toString()]),
    'averageRating': newUserAvgRating,
    'totalReviews': userReviewCount,
  });
}

Future<List<Media>> getAllFriendMedia() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final userSnapshot = await userRef.get();
  if (!userSnapshot.exists) return [];

  List<String> friendIds = List<String>.from(userSnapshot['friends'] ?? []);
  if (friendIds.isEmpty) return [];

  // Fetch all reviews from friends
  final reviewsSnapshot = await FirebaseFirestore.instance
      .collectionGroup('reviews')
      .where('userId', whereIn: friendIds)
      .orderBy('timestamp', descending: true)
      .get();

  // Create a map of mediaId to corresponding reviews
  Map<String, List<Rating>> mediaReviewMap = {};
  for (var review in reviewsSnapshot.docs) {
    String mediaId = review.reference.parent.parent?.id ?? "";
    if (mediaId.isNotEmpty) {
      if (!mediaReviewMap.containsKey(mediaId)) {
        mediaReviewMap[mediaId] = [];
      }
      mediaReviewMap[mediaId]!.add(Rating.fromJson(review.data()));
    }
  }

  if (mediaReviewMap.isEmpty) return [];

  List<Media> friendMediaList = [];
  List<String> mediaIdList = mediaReviewMap.keys.toList();

  // Fetch media details in batches of Firestore limit (10)
  for (int i = 0; i < mediaIdList.length; i += 10) {
    List<String> batch = mediaIdList.sublist(i, i + 10 > mediaIdList.length ? mediaIdList.length : i + 10);

    final mediaSnapshot = await FirebaseFirestore.instance
        .collection('media')
        .where(FieldPath.documentId, whereIn: batch)
        .get();

    for (var doc in mediaSnapshot.docs) {
      Media media = Media.fromFirestore(doc.data());

      media.ratings = mediaReviewMap[media.id.toString()] ?? [];
      media.reviewCount = media.ratings.length;

      // Calculate average rating and review count
      double totalVal = 0;
      for (var review in media.ratings) {
        totalVal += review.score;
      }
      media.averageRating = media.reviewCount > 0 ? totalVal / media.reviewCount : 0.0;

      friendMediaList.add(media);
    }
  }

  return friendMediaList;
}

  Future<void> getFriendReviewsForMedia(Media media) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) return;

    List<String> friendIds = List<String>.from(userSnapshot['friends'] ?? []);
    if (friendIds.isEmpty) return;

    List<Rating> allRatings = [];
    const int chunkSize = 10;
    for (int i = 0; i < friendIds.length; i += chunkSize) {
      List<String> batch = friendIds.sublist(i, i + chunkSize > friendIds.length ? friendIds.length : i + chunkSize);

      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('media')
          .doc(media.id.toString())
          .collection('reviews')
          .where('userId', whereIn: batch)
          .orderBy('timestamp', descending: true)
          .get();

      allRatings.addAll(reviewsSnapshot.docs.map((doc) => Rating.fromJson(doc.data())));
    }

    /*
    media.ratings = allRatings;
    media.reviewCount = allRatings.length; // ✅ Correctly updating review count

    double totalVal = 0;
    for (var review in allRatings) {
      totalVal += review.score;
    }

    media.averageRating = media.reviewCount > 0 ? totalVal / media.reviewCount : 0.0;
    */
  }
}