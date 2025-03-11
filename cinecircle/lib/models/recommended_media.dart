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
  factory RecommendedMedia.fromFirestore(Map<String, dynamic> json) {
    return RecommendedMedia(
      recommended: Media.fromFirestore(json['recommended']),
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
