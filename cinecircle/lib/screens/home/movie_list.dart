import 'package:flutter/material.dart';
// import '../../services/api_service.dart'; TODO: add API
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/widgets/movie_card.dart';
import '../../screens/home/movie_detail.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
//    futureMovies = ApiService.fetchMovies(); TODO: Fetch movies from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Ratings")),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading movies"));
          }
          return ListView(
            children: snapshot.data!.map((movie) => 
              MovieCard(movie: movie, onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MovieDetail(movie: movie),
                ));
              }),
            ).toList(),
          );
        },
      ),
    );
  }
}
