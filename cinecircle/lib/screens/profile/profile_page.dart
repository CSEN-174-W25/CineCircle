import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/profile/average_rating.dart';
import 'package:cinecircle/screens/profile/user_description.dart';
import 'package:cinecircle/screens/profile/favorite_movies.dart';
import 'package:cinecircle/models/movie_entry.dart';
import 'package:cinecircle/screens/profile/recent_watch.dart';

class ProfilePage extends StatefulWidget {
    const ProfilePage({super.key});

    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User johnDoe = User(
    userId: "doe3954",
    username: "John Doe",
    averageRating: 4.3,
    friendsAmount: 15,
    picUrl: "https://static.vecteezy.com/system/resources/thumbnails/019/879/186/small_2x/user-icon-on-transparent-background-free-png.png",
    bio: "Yippee0YippeeYippeeYippeeYippeeYippeeYippeeYippeeYippee ദ്ദി •⩊• )",
    watched: 45,
    friends: ["Bingus", "Bongus", "Bizzle", "Bungle"],
    reviewedMedias: ["Pluh"],
    top4: [
      Media(
        title: "La Haine",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/iH8saz6s0Z8SPPrKaMI2KrRzTED.jpg",
        releaseDate: "Eh",
        id: 1,
        mediaType: "Movie",
        overview:"Eh",
        reviewCount: 5,
      ),
      Media(
        title: "Ghost Dog: The Way of the Samurai",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/gkH4zOxIfbb4BEbk9Q4cVOEpDaY.jpg",
        releaseDate: "Eh",
        id: 2,
        mediaType: "Movie",
        overview:"Eh",
        reviewCount: 5
      ),
      Media(
        title: "Buffalo '66",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/fxzXFzbSGNA52NHQCMqQiwzMIQw.jpg",
        releaseDate: "Eh",
        id: 3,
        mediaType:"Movie",
        overview:"Eh",
        reviewCount: 5
      ),
      Media(
        title: "Clerks",
        imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/9IiSgiq4h4siTIS9H3o4nZ3h5L9.jpg",
        releaseDate: "Eh",
        id: 4,
        mediaType:"Movie",
        overview:"Eh",
        reviewCount: 5
      )
    ],
    watchlist: [
      MediaEntry(
        media: Media(
          title: "La Haine",
          imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/iH8saz6s0Z8SPPrKaMI2KrRzTED.jpg",
          releaseDate: "Eh",
          id: 5,
          mediaType:"Movie",
          overview:"Eh",
          reviewCount: 3
          ),
        watchdate: DateTime.utc(1989, 11, 9),
        score: 4.5
      ),
      MediaEntry(
        media: Media(
          title: "Ghost Dog: The Way of the Samurai",
          imageUrl: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/gkH4zOxIfbb4BEbk9Q4cVOEpDaY.jpg",
          releaseDate: "Eh",
          id: 6,
          mediaType:"Movie",
          overview:"Eh",
          reviewCount:3
        ),
        watchdate: DateTime.utc(1991, 8, 7),
        score: 4.8
      ),
    ]
  );

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Cinecircle")),
        body: SingleChildScrollView(
         // child: Center( // Center the Column
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), 
                UserDescription(user: johnDoe),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  "Favorite Media",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                FavoriteMovies(user: johnDoe),
                SizedBox(height: 20), // Add spacing between widgets
                Text("Average User Rating",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AverageRating(user: johnDoe),
                SizedBox(height: 20),
                Text("Recently Watched",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RecentWatch(user: johnDoe)
              ],
            ),
          //),
        ),
      );
    }
}
