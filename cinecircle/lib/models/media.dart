import 'rating.dart';
import 'package:intl/intl.dart';

class Media {
  final String title;
  final String releaseDate;
  final String imageUrl;
  final String mediaType;
  final String overview;
  final int id;
  double averageRating;
  List<Rating> ratings;

  Media({
    required this.title,
    required this.releaseDate,
    required this.id,
    required this.mediaType,
    required this.overview,
    required this.imageUrl,
    this.averageRating = 0.0,
    List<Rating>? ratings,
  }) : ratings = ratings ?? [];

  // Parse JSON from TMDb API
  factory Media.fromJson(Map<String, dynamic> json) {
    String usaDate = "Unknown";

    // Use release_date for movies, first_air_date for TV shows
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
      averageRating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      id: json['id'] as int? ?? 0,
      mediaType: json['media_type'] ?? "unknown",
      overview: json['overview'] ?? "",
      ratings: [],
    );
  }

  void addRating(Rating newRating) {
    ratings.add(newRating);
    averageRating = ratings.isNotEmpty
        ? ratings.fold(0.0, (sum, r) => sum + r.score) / ratings.length
        : 0.0;
  }
}
