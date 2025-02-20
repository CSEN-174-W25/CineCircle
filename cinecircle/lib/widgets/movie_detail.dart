import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;

  const MovieDetail({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie.imageUrl), // Show movie poster
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ratings:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: movie.ratings.map((rating) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text("${rating.userId} rated ${rating.score}/5."),
                  subtitle: Text(rating.comment ?? ""),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
