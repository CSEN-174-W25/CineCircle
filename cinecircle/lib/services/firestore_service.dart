/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';

class FirestoreService {
  /// 🔹 Firestore Collection Reference (Auto Converts `Media`)
  final CollectionReference<Media> _mediaCollection =
      FirebaseFirestore.instance.collection('medias').withConverter<Media>(
            fromFirestore: (snap, _) => Media.fromJson(snap.data()!),
            toFirestore: (media, _) => media.toJson(),
          );

  /// Fetches movies as a stream (real-time updates)
  Stream<List<Media>> streamMedias() {
    return _mediaCollection.snapshots().asyncMap((snapshot) async {
      List<Media> medias = [];

      for (var doc in snapshot.docs) {
        Media media = doc.data() as Media;

        // Fetch all ratings for this media
        QuerySnapshot ratingsSnapshot =
            await doc.reference.collection('ratings').get();

        List<Rating> ratings = ratingsSnapshot.docs.map((ratingDoc) {
          var ratingData = ratingDoc.data() as Map<String, dynamic>;
          return Rating(
            userId: ratingDoc.id,
            score: (ratingData['rating'] as num?)?.toDouble() ?? 0.0,
            review: ratingData['review'] ?? "",
          );
        }).toList();

        // Calculate average rating
        double averageRating = ratings.isNotEmpty
            ? ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length
            : 0.0;

        // Update media object with ratings and average rating
        media = media.copyWith(
          ratings: ratings,
          averageRating: averageRating,
        );

        medias.add(media);
      }

      return medias;
    });
  }

  Future<List<Media>> getMedias() async {
    QuerySnapshot snapshot = await _mediaCollection.get();

    List<Media> medias = [];

    for (var doc in snapshot.docs) {
      Media media = doc.data() as Media;

      // Fetch ratings for this media
      QuerySnapshot ratingsSnapshot =
          await doc.reference.collection('ratings').get();

      List<Rating> ratings = ratingsSnapshot.docs.map((ratingDoc) {
        var ratingData = ratingDoc.data() as Map<String, dynamic>;
        return Rating(
          userId: ratingDoc.id,
          score: (ratingData['rating'] as num?)?.toDouble() ?? 0.0,
          review: ratingData['review'] ?? "",
        );
      }).toList();

      // Calculate average rating
      double averageRating = ratings.isNotEmpty
          ? ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length
          : 0.0;

      // Update media object with ratings and average rating
      media = media.copyWith(
        ratings: ratings,
        averageRating: averageRating,
      );

      medias.add(media);
    }

    return medias;
  }
}
*/