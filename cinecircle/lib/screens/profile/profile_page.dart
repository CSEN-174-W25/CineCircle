// User Profile Page

import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/profile/average_rating.dart';
import 'package:cinecircle/screens/profile/user_description.dart';
import 'package:cinecircle/screens/profile/favorite_movies.dart';
import 'package:cinecircle/screens/profile/friend_button.dart';

class ProfilePage extends StatefulWidget {
    const ProfilePage({super.key});

    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /*
    void _friended(User user){
        user.friendsAmount += 1;    // Increases user's friend count
        //Need to add specific user who friended to the friendlist
    }
  */

  User johnDoe = User(
    userId: "doe3954",
    username: "John Doe",
    averageRating: 4.3,
    friendsAmount: 15,
    picUrl: "https://static.vecteezy.com/system/resources/thumbnails/019/879/186/small_2x/user-icon-on-transparent-background-free-png.png",
    bio: "Yippee ദ്ദി •⩊• )",
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Adjust height for centering
                UserDescription(user: johnDoe),
                FriendRequestButton(),
                SizedBox(height: 20), // Add spacing between widgets
                Text(
                  "Favorite Medias",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FavoriteMovies(user: johnDoe),
                SizedBox(height: 20), // Add spacing between widgets
                Text("Average User Rating",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AverageRating(user: johnDoe)
              ],
            ),
          //),
        ),
      );
    }
}
