import 'rating.dart';

class Movie {
  final String title;
  String? year;
  final String imageUrl;
  double averageRating;
  final List<Rating> ratings;

  Movie({
    required this.title,
    this.year,
    required this.imageUrl,
    this.averageRating = 0.0,
    List<Rating>? ratings,
  }) : ratings = ratings ?? [];

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      year: json['year'],
      imageUrl: json['imageUrl'] ?? '',
      averageRating: (json['averageRating'] as num).toDouble(),
      ratings: (json['ratings'] as List)
          .map((rating) => Rating.fromJson(rating))
          .toList(),
    );
  }

    void addRating(Rating newRating) {
    ratings.add(newRating); // Add the new rating
    if (ratings.isNotEmpty) {
      averageRating =
          ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    }
  }
}
