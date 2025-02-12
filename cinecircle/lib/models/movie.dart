import 'rating.dart';

class Movie {
  final String id;
  final String title;
  String? year;
  final String imageUrl;
  final double averageRating;
  final List<Rating> ratings;

  Movie({
    required this.id,
    required this.title,
    this.year,
    required this.imageUrl,
    this.averageRating = 0.0,
    List<Rating>? ratings,
  }) : ratings = ratings ?? [];

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      imageUrl: json['imageUrl'] ?? '',
      averageRating: (json['averageRating'] as num).toDouble(),
      ratings: (json['ratings'] as List)
          .map((rating) => Rating.fromJson(rating))
          .toList(),
    );
  }
}
