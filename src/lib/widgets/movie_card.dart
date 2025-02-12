import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(movie.imageUrl, width: 50, fit: BoxFit.cover),
        title: Text(movie.title),
        subtitle: Text("⭐ ${movie.averageRating.toStringAsFixed(1)} / 5"),
        onTap: onTap,
      ),
    );
  }
}