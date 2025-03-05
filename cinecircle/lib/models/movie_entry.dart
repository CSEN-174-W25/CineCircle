import 'movie.dart';

class MovieEntry {
  final Movie movie;
  final DateTime watchdate;
  double? score;

  MovieEntry({
      required this.movie,
      required this.watchdate,
      this.score     //Default -1 so that rating invisible when unrated
  });

  factory MovieEntry.fromJson(Map<String, dynamic> json){
    return MovieEntry(
      movie: Movie.fromJson(json['movie']),
      watchdate: DateTime.parse(json['watchdate']),
      score: (json['score'] as num).toDouble()
    );
  }
}

