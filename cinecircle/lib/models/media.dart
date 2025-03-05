import 'rating.dart';
import 'package:intl/intl.dart';

class Media {
  final String title;
  final String releaseDate;
  final String imageUrl;
  final String mediaType;
  final String overview;
  final int id;
  int reviewCount;
  double averageRating;
  List<Rating> ratings;

  Media({
    required this.title,
    required this.releaseDate,
    required this.id,
    required this.mediaType,
    required this.overview,
    required this.imageUrl,
    required this.reviewCount,
    this.averageRating = 0.0,
    List<Rating>? ratings,
  }) : ratings = ratings ?? [];

  factory Media.fromJson(Map<String, dynamic> json) {
    String usaDate = "Unknown";
    String? rawDate = json['release_date'] ?? json['first_air_date'];

    if (rawDate != null && rawDate.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(rawDate);
        usaDate = DateFormat('MM-dd-yyyy').format(parsedDate);
      } catch (e) {
        usaDate = "Unknown"; // Fallback in case of parsing errors
      }
    }

    return Media(
      title: json['title'] ?? json['name'] ?? "Unknown",
      releaseDate: usaDate,
      imageUrl: (json['poster_path'] != null && json['poster_path'].isNotEmpty)
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "assets/images/placeholder.png",  // Uses placeholder image if missing
      averageRating: 0.0,
      id: json['id'] as int? ?? 0,
      mediaType: json['media_type'] ?? "unknown",
      overview: json['overview'] ?? "",
      ratings: [],
      reviewCount: json.containsKey('vote_count') 
          ? (json['vote_count'] as num?)?.toInt() ?? 0 
          : 0,
    );
  }

  /// Parse from Firestore
  factory Media.fromFirestore(Map<String, dynamic> json) {
    return Media(
      title: json['title'] ?? "Unknown",
      releaseDate: json['releaseDate'] ?? "Unknown",
      imageUrl: json['imageUrl'] ?? "assets/images/placeholder.png",
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      id: json['mediaId'] as int? ?? 0,
      mediaType: json['mediaType'] ?? "unknown",
      overview: json['overview'] ?? "",
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert to Firestore Format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'releaseDate': releaseDate,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
      'mediaId': id,
      'mediaType': mediaType,
      'overview': overview,
      'reviewCount': reviewCount,
    };
  }
}
