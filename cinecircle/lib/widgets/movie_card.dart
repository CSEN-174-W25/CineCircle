import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({required this.movie, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,  // Navigate when tapped
            child: Image.network(
              movie.imageUrl,  // Assuming `posterUrl` holds the movie image URL
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
