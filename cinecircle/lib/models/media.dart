import 'rating.dart';

class Media {
  final String title;
  final String? year;
  final String imageUrl;
  double averageRating;
  List<Rating> ratings;

  Media({
    required this.title,
    this.year,
    required this.imageUrl,
    this.averageRating = 0.0,
    List<Rating>? ratings,
  }) : ratings = ratings ?? [];

  // Parse JSON from TMDb API
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      title: json['title'] ?? json['name'] ?? "Unknown",
      year: (json['release_date'] != null && json['release_date'].length >= 4)
          ? json['release_date'].substring(0, 4)
          : (json['first_air_date'] != null && json['first_air_date'].length >= 4)
              ? json['first_air_date'].substring(0, 4)
              : null,
      imageUrl: (json['poster_path'] != null && json['poster_path'].isNotEmpty)
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "assets/images/placeholder.png",  // Uses placeholder image if missing
      averageRating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      ratings: json['ratings'] != null
          ? (json['ratings'] as List)
              .map((rating) => Rating.fromJson(rating))
              .toList()
          : [],
    );
  }

  // Convert to JSON For Storing in Firebase
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "year": year,
      "imageUrl": imageUrl,
      "averageRating": averageRating,
      "ratings": ratings.map((r) => r.toJson()).toList(),
    };
  }

  void addRating(Rating newRating) {
    ratings.add(newRating);
    if (ratings.isNotEmpty) {
      averageRating =
          ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    }
  }
}