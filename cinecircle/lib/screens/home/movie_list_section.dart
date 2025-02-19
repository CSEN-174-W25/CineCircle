import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';
import '../../../widgets/movie_card.dart';
import 'share_your_thoughts.dart';

class MovieListSection extends StatelessWidget {
  final List<Movie> movies;
  final Movie? selectedMovie;
  final Function(Movie) onMovieSelected;
  final Function(Rating) onReviewAdded;

  const MovieListSection({
    required this.movies,
    required this.selectedMovie,
    required this.onMovieSelected,
    required this.onReviewAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: movies.map((movie) {
        return Column(
          children: [
            MovieCard(
              movie: movie,
              onTap: () => onMovieSelected(movie), // Handle movie selection
            ),
            if (selectedMovie == movie) // Show ShareYourThoughts under selected movie
              ShareYourThoughts(
                movie: movie,
                onReviewAdded: onReviewAdded,
              ),
          ],
        );
      }).toList(),
    );
  }
}
