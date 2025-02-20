import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';

class FriendActivitySection extends StatelessWidget {
  final List<Rating> reviews;
  final List<Movie> movies;
  final void Function(Movie) onMovieTap;

  const FriendActivitySection({
    required this.reviews,
    required this.movies,
    required this.onMovieTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Friend Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (reviews.isEmpty)
            Text("No reviews yet.")
          else
            // Loop through movies that have reviews
            Column(
              children: movies.map((movie) {
                // Check if movie has any reviews
                if (movie.ratings.isNotEmpty) {
                  return GestureDetector(
                    onTap: () => onMovieTap(movie),
                    child: Card(
                      child: Column(
                        children: [
                          Image.network(
                            movie.imageUrl,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Text(movie.title),
                          ListTile(
                            title: Text("Average Rating: ${movie.averageRating}/5."),
                            subtitle: Text("Total Reviews: ${movie.ratings.length}"),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }).toList(),
            ),
        ],
      ),
    );
  }
}
