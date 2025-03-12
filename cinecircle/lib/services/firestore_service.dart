import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  Future<void> saveReview({
    required Media reviewedMedia,
    required Rating userReview,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final mediaRef = FirebaseFirestore.instance.collection('media').doc(reviewedMedia.id.toString());

    final userRatingRef = userRef.collection('reviews').doc(reviewedMedia.id.toString());
    final mediaRatingRef = mediaRef.collection('reviews').doc(user.uid);

    final mediaSnapshot = await mediaRef.get();
    if (!mediaSnapshot.exists) {
      await mediaRef.set(reviewedMedia.toFirestore());
    }

    final ratingData = {
      'userId': user.uid,
      'username': userReview.username,
      'review': userReview.review,
      'score': userReview.score,
      'timestamp': FieldValue.serverTimestamp(),
    };

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.set(userRatingRef, ratingData);
    batch.set(mediaRatingRef, ratingData);

    await batch.commit();

    final userRatingsSnapshot = await userRef.collection('reviews').get();

    double totalUserRating = 0;
    int userReviewCount = userRatingsSnapshot.docs.length;

    for (var doc in userRatingsSnapshot.docs) {
      totalUserRating += (doc['score'] as num).toDouble();
    }

    double newUserAvgRating = userReviewCount > 0 ? totalUserRating / userReviewCount : 0.0;

    await userRef.update({
      'reviewedMedias': FieldValue.arrayUnion([reviewedMedia.id.toString()]),
      'averageRating': newUserAvgRating,
      'totalReviews': userReviewCount,
    });
  }

  // Real-time Stream for Friend Media
  Stream<List<Media>> getAllFriendMedia() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return userRef.snapshots().asyncMap((userSnapshot) async {
      if (!userSnapshot.exists) return [];

      List<String> friendIds = List<String>.from(userSnapshot['friends'] ?? []);
      if (friendIds.isEmpty) return [];

      Map<String, List<Rating>> mediaReviewMap = {};
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collectionGroup('reviews')
          .where('userId', whereIn: friendIds)
          .orderBy('timestamp', descending: true)
          .get();

      for (var review in reviewsSnapshot.docs) {
        String mediaId = review.reference.parent.parent?.id ?? "";
        if (mediaId.isNotEmpty) {
          mediaReviewMap.putIfAbsent(mediaId, () => []);
          mediaReviewMap[mediaId]!.add(Rating.fromJson(review.data()));
        }
      }

      List<Media> friendMediaList = [];
      for (var mediaId in mediaReviewMap.keys) {
        final mediaDoc = await FirebaseFirestore.instance
            .collection('media')
            .doc(mediaId)
            .get();

        if (mediaDoc.exists) {
          Media media = Media.fromFirestore(mediaDoc.data()!);
          media.ratings = mediaReviewMap[mediaId]!;
          media.reviewCount = media.ratings.length;

          double totalScore = media.ratings.fold(0, (sum, review) => sum + review.score);
          media.averageRating = media.reviewCount > 0 ? totalScore / media.reviewCount : 0.0;

          friendMediaList.add(media);
        }
      }

      return friendMediaList;
    });
  }

  // Real-time Stream for All Friend Reviews
  Stream<List<Rating>> getFriendReviewsForMedia(Media media) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return userRef.snapshots().asyncMap((userSnapshot) async {
      if (!userSnapshot.exists) return [];

      List<String> friendIds = List<String>.from(userSnapshot['friends'] ?? []);
      if (friendIds.isEmpty) return [];

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

      return allRatings;
    });
  }

  Future<List<Media>> getRecentFourMedia(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || userDoc.data()?['reviewedMedias'] == null) {
        return [];
      }

      List<dynamic> reviewedMediaIds = userDoc.data()?['reviewedMedias'] ?? [];
      if (reviewedMediaIds.isEmpty) {
        return [];
      }

      // Take the last 4 entries
      final recentMediaIds = reviewedMediaIds.reversed.take(4).toList();
      // Fetch media details for the IDs
      final mediaDetails = await Future.wait(
        recentMediaIds.map((id) async {
          final mediaDoc = await FirebaseFirestore.instance
              .collection('media')
              .doc(id.toString())
              .get();

          if (mediaDoc.exists && mediaDoc.data() != null) {
            return Media.fromFirestore(mediaDoc.data()!);
          } else {
            return null;
          }
        }),
      );

      final validMediaList = mediaDetails.whereType<Media>().toList();

      return validMediaList;

    } catch (e) {
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

/*
    Future<List<Media>> getTopFourMedia(String userId) async {
      try {
        final ratingsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('reviews')
            .orderBy('score', descending: true)
            .limit(4)
            .get();

        if (ratingsSnapshot.docs.isEmpty) return [];

        List<Media> topMovies = [];
        for (var doc in ratingsSnapshot.docs) {
          final mediaDoc = await FirebaseFirestore.instance
              .collection('media')
              .doc(doc.id)
              .get();

          if (mediaDoc.exists) {
            topMovies.add(Media.fromFirestore(mediaDoc.data()!));
          }
        }

        return topMovies;
      } catch (error) {
        print("Error fetching top-rated media: $error");
        return [];
      }
    }
    */

  // Real-time Stream for User Profile
  Stream<model.User?> getUser(String userId) {
    int retryCount = 0;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .debounceTime(const Duration(milliseconds: 500))
        .asyncMap((snapshot) async {
        if (!snapshot.exists || snapshot.data() == null) {
          return null;
        }

        if (retryCount >= 3) {
          return null;
        }

        final user = model.User.fromJson(snapshot.data()!);

        try {
          final results = await Future.wait([
            getRecentFourMedia(userId).catchError((_) => <Media>[]),
            //getTopFourMedia(userId).catchError((_) => <Media>[]),
          ]);

          user.watchlist = results[0];
          //user.topFour = results[1];

          retryCount = 0; 
          return user;

        } 
        catch (e) {
          retryCount++;
            return null;
        }
    });
  }

  Future<model.User?> getCurrentUserProfile() async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        print("No authenticated user found.");
        return null; // Not logged in
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        print("User profile not found in Firestore.");
        return null;
      }

      return model.User.fromJson(userDoc.data()!);
    } catch (e) {
      return null; // Handle Firestore errors
    }
  }

  Future<void> ensureFavField(String userId) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    DocumentSnapshot userDoc = await userRef.get();
    if (!userDoc.exists || !userDoc.data().toString().contains('topFour')) {
      await userRef.set({
        'topFour': List.generate(4, (_) => ""),
      }, SetOptions(merge: true));
    }
  }

  Future<String?> getFav(String userId, int index) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      List<dynamic>? favoriteMedia = userDoc['topFour'] as List<dynamic>?;

      if (favoriteMedia != null && index >= 0 && index < favoriteMedia.length) {
        return favoriteMedia[index].toString();
      }
    }
    return null;
  }

  Future<List<Media>> getReviewedMedia(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception("User not found");
    }

    List<dynamic>? reviewedMediaIds = userDoc['reviewedMedias'] as List<dynamic>?;

    if (reviewedMediaIds == null || reviewedMediaIds.isEmpty) {
      return []; 
    }

    QuerySnapshot mediaQuery = await FirebaseFirestore.instance
        .collection('media')
        .where(FieldPath.documentId, whereIn: reviewedMediaIds)
        .orderBy('title') 
        .get();

    return mediaQuery.docs.map((doc) => Media.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }
  

  static final Map<String, Media> _mediaCache = {};

  Media? getMediaFromCache(String mediaId) {
    return _mediaCache[mediaId];
  }

  
  Future<Media> fetchMedia(String mediaId) async {
    if (_mediaCache.containsKey(mediaId)) {
      return _mediaCache[mediaId]!;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('media').doc(mediaId).get();
    if (!doc.exists) throw Exception("Media not found");

    var data = doc.data() as Map<String, dynamic>?;
    
    if (data == null){
      throw Exception("Movie data is null");
    }

    Media media = Media.fromFirestore(data);
    _mediaCache[mediaId] = media;
    return media;
  }
  
  Future<void> updateFavMedia(String userId, int index, int mediaId) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    DocumentSnapshot userDoc = await userRef.get();
    if (!userDoc.exists) return;

    List<dynamic> topFour = userDoc['topFour'] ?? ["", "", "", ""]; 
    topFour[index] = mediaId.toString();

    await userRef.update({'topFour': topFour});
  }
}