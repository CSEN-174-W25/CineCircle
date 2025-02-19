import 'package:flutter/material.dart';
import 'package:cinecircle/screens/home/friend_activity_section.dart';
import 'package:cinecircle/screens/home/movie_list_section.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Movie? selectedMovie;
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

  void _selectMovie(Movie movie) {
    setState(() {
      selectedMovie = (selectedMovie == movie) ? null : movie; // Toggle selection
    });
  }

  void _addReview(Rating rating) {
    setState(() {
      friendReviews.add(rating);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
@override
Widget build(BuildContext context) {
  List<Widget> _pages = [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                MovieListSection(
                  movies: movies,
                  selectedMovie: selectedMovie, 
                  onMovieSelected: _selectMovie,
                  onReviewAdded: _addReview,
                ),
                FriendActivitySection(reviews: friendReviews),
              ],
            ),
          ),
        ],
      ),
    ),
    Center(child: Text("Notifications Page")), 
    Center(child: Text("Profile Page")), 
  ];

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "CineCircle",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          fontFamily: 'Inter Tight',
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 52, 52), Color.fromARGB(255, 194, 0, 161)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
    body: _pages[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: "Notifications"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    ),
  );
  }
}