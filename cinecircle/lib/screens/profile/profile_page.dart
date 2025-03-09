import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/profile/average_rating.dart';
import 'package:cinecircle/screens/profile/user_description.dart';
import 'package:cinecircle/screens/profile/favorite_movies.dart';
import 'package:cinecircle/screens/profile/recent_watch.dart';
import 'package:cinecircle/services/firestore_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage(this.userId, {super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  bool isLoading = true; // Track loading state for loading circle

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

Future<void> fetchUserData() async {
  if (!mounted) return; // Ensure widget is still in the tree before proceeding

  if (widget.userId == null) {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    return;
  }

  User? user = await FirestoreService().getUser(widget.userId!);
  if (!mounted) return; // Double-check after async operation

  user!.watchlist = await FirestoreService().getRecentFourMedia(widget.userId!);

  if (!mounted) return; // Double-check again in case widget got removed during this call

  user.topFour = [
    Media(
      title: "La Haine",
      imageUrl: "https://image.tmdb.org/t/p/w500/qNLMPY3KLrYgTX2QZ5iEwwOqyRz.jpg",
      mediaType: "movie",
      id: 24,
      overview: "Aimlessly whiling away their days in the concrete environs of their dead-end suburbia, Vinz, Hubert, and Said",
      releaseDate: "09-19-2024",
      reviewCount: 0,
      averageRating: 0.0,
    ),
    Media(
      title: "La Bamba",
      imageUrl: "https://image.tmdb.org/t/p/w500/qNLMPY3KLrYgTX2QZ5iEwwOqyRz.jpg",
      mediaType: "movie",
      id: 24,
      overview: "Aimlessly whiling away their days in the concrete environs of their dead-end suburbia, Vinz, Hubert, and Said",
      releaseDate: "09-19-2024",
      reviewCount: 0,
      averageRating: 0.0,
    ),
    Media(
      title: "El Haine",
      imageUrl: "https://image.tmdb.org/t/p/w500/1ZEJuuDh0Zpi5ELM3Zev0GBhQ3R.jpg",
      mediaType: "movie",
      id: 24,
      overview: "Aimlessly whiling away their days in the concrete environs of their dead-end suburbia, Vinz, Hubert, and Said",
      releaseDate: "09-19-2024",
      reviewCount: 0,
      averageRating: 0.0,
    ),
    Media(
      title: "The Movie",
      imageUrl: "https://image.tmdb.org/t/p/w500/qNLMPY3KLrYgTX2QZ5iEwwOqyRz.jpg",
      mediaType: "movie",
      id: 24,
      overview: "Aimlessly whiling away their days in the concrete environs of their dead-end suburbia, Vinz, Hubert, and Said",
      releaseDate: "09-19-2024",
      reviewCount: 0,
      averageRating: 0.0,
    )
  ];
  
  user.picUrl = "https://static.vecteezy.com/system/resources/thumbnails/019/879/186/small_2x/user-icon-on-transparent-background-free-png.png";
  user.bio = "Yippee0YippeeYippeeYippeeYippeeYippeeYippeeYippeeYippee ദ്ദി •⩊• )";

  if (mounted) {
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }
}

    @override
  Widget build(BuildContext context) {

    /*

    picUrl: "https://static.vecteezy.com/system/resources/thumbnails/019/879/186/small_2x/user-icon-on-transparent-background-free-png.png",
    bio: "Yippee0YippeeYippeeYippeeYippeeYippeeYippeeYippeeYippee ദ്ദി •⩊• )",
    top4: [
      Movie(
        title: "La Haine",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/iH8saz6s0Z8SPPrKaMI2KrRzTED.jpg",
      ),
      Movie(
        title: "Ghost Dog: The Way of the Samurai",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/gkH4zOxIfbb4BEbk9Q4cVOEpDaY.jpg",
      ),
      Movie(
        title: "Buffalo '66",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/fxzXFzbSGNA52NHQCMqQiwzMIQw.jpg"
      ),
      Movie(
        title: "Clerks",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/9IiSgiq4h4siTIS9H3o4nZ3h5L9.jpg"
      )
    ],
    watchlist: [
      MovieEntry(
        movie: Movie(
          title: "La Haine",
          imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/iH8saz6s0Z8SPPrKaMI2KrRzTED.jpg",
          ),
        watchdate: DateTime.utc(1989, 11, 9),
        score: 4.5
      ),
    ]
  );
  */

      if (isLoading) {
        return Scaffold(
          appBar: AppBar(title: Text("Profile")),
          body: Center(child: CircularProgressIndicator()), // Show loading spinner
        );
      }

      if (currentUser == null) {
        return Scaffold(
          appBar: AppBar(title: Text("Profile")),
          body: Center(child: Text("User not found")),
        );
      }
      return Scaffold(
        appBar: AppBar(title: Text("Cinecircle")),
        body: SingleChildScrollView(
         // child: Center( // Center the Column
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), 
                UserDescription(user: currentUser!),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  "Favorite Media",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                FavoriteMovies(user: currentUser!),
                SizedBox(height: 20), // Add spacing between widgets
                Text("Average User Rating",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AverageRating(user: currentUser!),
                SizedBox(height: 20),
                Text("Recently Watched",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RecentWatch(user: currentUser!)
              ],
            ),
          //),
        ),
      );
    }
}