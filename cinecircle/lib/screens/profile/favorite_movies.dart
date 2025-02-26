// Displays the user's top 4 favorite movies
import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/movie.dart';

class FavoriteMovies extends StatefulWidget{
  final User user;

  const FavoriteMovies({
    required this.user,
    super.key
  });

    @override
   _FavoriteMoviesState createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.user.top4.map((movie) { // Iterate over top4 movies
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            movie.imageUrl,
            width: 100, // Set a fixed width
            height: 150, // Set a fixed height
            fit: BoxFit.cover, // Ensure the image fits well
          ),
        );
      }).toList(),
    );
  }
}