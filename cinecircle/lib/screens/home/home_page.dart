import 'package:flutter/material.dart';
import 'package:cinecircle/screens/home/friend_activity_section.dart';
import 'package:cinecircle/screens/home/movie_list_section.dart';
import 'package:cinecircle/screens/notifications/notification_page.dart';
import 'package:cinecircle/screens/profile/profile_page.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;  // Current selected index for BottomNavigationBar
  Movie? selectedMovie;
  // TODO: delete when Firebase is integrated
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
      selectedMovie = (selectedMovie == movie) ? null : movie;
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
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      Column(
        children: [
          Expanded(
            child: ListView(
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
      NotificationPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("CineCircle"),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}