import 'media.dart';

class RecommendedMedia {
  final Media recommended;
  final String sentById;
  final String sentByUsername;

  RecommendedMedia({
    required this.recommended,
    required this.sentById,
    required this.sentByUsername,
  });

  /// Parse from Firestore
  factory RecommendedMedia.fromFirestore(Map<String, dynamic>? json) {
    if (json == null || json['recommended'] == null) {
      return RecommendedMedia(
        recommended: Media(
          title: "Unknown",
          id: 0,
          imageUrl: "",
          mediaType: "unknown",
          overview: "",
          releaseDate: "",
          reviewCount: 0,
          averageRating: 0.0,
        ),
        sentById: json?['sentById'] ?? "",
        sentByUsername: json?['sentByUsername'] ?? "",
      );
    }

    // Check for 'recommended' structure
    final recommendedData = json['recommended'] as Map<String, dynamic>?;

    return RecommendedMedia(
      recommended: recommendedData != null
          ? Media.fromFirestore(recommendedData)
          : Media(
              title: "Unknown",
              id: 0,
              imageUrl: "",
              mediaType: "unknown",
              overview: "",
              releaseDate: "",
              reviewCount: 0,
              averageRating: 0.0,
            ),
      sentById: json['sentById'] ?? "",
      sentByUsername: json['sentByUsername'] ?? "",
    );
  }

  /// Convert to Firestore Format
  Map<String, dynamic> toFirestore() {
    return {
      'recommended': recommended.toFirestore(),
      'sentById': sentById,
      'sentByUsername': sentByUsername,
    };
  }
}