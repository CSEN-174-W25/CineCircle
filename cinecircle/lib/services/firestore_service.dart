import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> rateMovie(Media uploadMedia, int rating, String review) async {
    final movieRef = FirebaseFirestore.instance.collection('medias').doc(uploadMedia.id.toString());
    final ratingRef = movieRef.collection('ratings').doc("user123");

    // Check if movie exists
    DocumentSnapshot movieSnapshot = await movieRef.get();

    if (!movieSnapshot.exists) {
      // If movie doesn't exist, create it
      await movieRef.set({
        'title': uploadMedia.title,
        'posterUrl': uploadMedia.imageUrl,
        'releaseDate': uploadMedia.releaseDate,
        'mediaType': uploadMedia.mediaType,
        'overview': uploadMedia.overview,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    // Add/update user's rating
    await ratingRef.set({
      'rating': rating,
      'review': review,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


  /// Retrieves all medias from Firestore
  Future<List<Map<String, dynamic>>> getMedias() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('medias').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error getting medias: $e");
      return [];
    }
  }
}