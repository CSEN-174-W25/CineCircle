import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/models/user.dart' as model;
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
  }

  Future<model.User?> getUser(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (!userDoc.exists || userDoc.data() == null) {
        return null; // Return null if user does not exist
      }
      return model.User.fromJson(userDoc.data()!);
    } catch (error) {
      print("Error fetching user: $error");
      return null;
    }
  }

  Future<List<Media>> getRecentFourMedia(String userId) async {
    try {
      final mediaQuery = await FirebaseFirestore.instance
        .collectionGroup('reviews')  
        .where(FieldPath.documentId, isEqualTo: userId)  
        .orderBy('timestamp', descending: true)  
        .limit(4)  
        .get();
      /*
          .collection('media')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // Get 4 most recent first
          .limit(4)
          .get();

      if (mediaQuery.docs.isEmpty) {
        return [];
      }

      return mediaQuery.docs.map((doc) => Media.fromJson(doc.data())).toList();
      */
      List<Media> recentMedias = [];

      for (var reviewDoc in mediaQuery.docs) {
        DocumentReference mediaRef = reviewDoc.reference.parent.parent!; 

        final mediaSnapshot = await mediaRef.get();
        if (mediaSnapshot.exists) {
          recentMedias.add(Media.fromJson(mediaSnapshot.data() as Map<String, dynamic>));
      }
    }

    return recentMedias;

    } 
    catch (error) {
      print("Error fetching recent media for user: $error");
      return [];
    }
  }

  Future<void> updateUserField(String userId, {String? newUsername, String? newBio}) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      Map<String, dynamic> updatedFields = {};

      if (newUsername != null) {
        updatedFields['username'] = newUsername;
      }

      if (newBio != null) {
        updatedFields['bio'] = newBio;
      }

      if (updatedFields.isNotEmpty) {
        await userRef.update(updatedFields);
        print("User field(s) updated successfully!");
      } else {
        print("No new field to update");
      }
    } catch (error) {
      print("Error updating user field: $error");
    }
  }


}