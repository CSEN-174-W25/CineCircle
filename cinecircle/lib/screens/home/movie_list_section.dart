import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import '../../../widgets/movie_card.dart';

class MovieListSection extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieSelected; // Callback function

  const MovieListSection({required this.movies, required this.onMovieSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: movies.map((movie) => MovieCard(
        movie: movie,
        onTap: () => onMovieSelected(movie), // Notify parent when a movie is clicked
      )).toList(),
    );
  }
}
