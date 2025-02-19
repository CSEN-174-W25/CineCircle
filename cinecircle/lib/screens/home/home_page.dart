import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/screens/home/friend_activity_section.dart';
import 'package:cinecircle/screens/home/share_your_thoughts.dart';
import 'package:cinecircle/screens/home/movie_list_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [
    Movie(
      title: "Inception",
      imageUrl: "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
    ),
    Movie(
      title: "Interstellar",
      imageUrl: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
    ),
  ];

  List<Rating> friendReviews = [];
  Movie? selectedMovie; // Store the selected movie

  void _addReview(Rating rating) {
    setState(() {
      friendReviews.add(rating);
    });
  }

  void _selectMovie(Movie movie) {
    setState(() {
      selectedMovie = movie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CineCircle")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieListSection(
              movies: movies,
              onMovieSelected: _selectMovie, // Pass the function to handle movie selection
            ),
            if (selectedMovie != null) // Only show review box if a movie is selected
              ShareYourThoughts(
                movie: selectedMovie!,
                onReviewAdded: _addReview,
              ),
            FriendActivitySection(reviews: friendReviews), // Show friend activity
          ],
        ),
      ),
    );
  }
}