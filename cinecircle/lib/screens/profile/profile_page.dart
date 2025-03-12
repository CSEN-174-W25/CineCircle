import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/profile/average_rating.dart';
import 'package:cinecircle/screens/profile/user_description.dart';
import 'package:cinecircle/screens/profile/favorite_movies.dart';
import 'package:cinecircle/screens/profile/recent_watch.dart';
import 'package:cinecircle/services/firestore_service.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        
        body: Center(child: Text("User not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "CineCircle",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Inter Tight",
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 52, 52),
                  Color.fromARGB(255, 194, 0, 161)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      body: StreamBuilder<User?>(
        stream: FirestoreService().getUser(userId!), // Real-time stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading spinner
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("User not found"));
          }

          final currentUser = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                UserDescription(user: currentUser),
                SizedBox(height: 20),

                Text(
                  "Favorite Media",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                FavoriteMovies(user: currentUser),
                SizedBox(height: 20),

                Text(
                  "Average User Rating",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AverageRating(user: currentUser),
                SizedBox(height: 20),

                Text(
                  "Recently Watched",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RecentWatch(user: currentUser)
              ],
            ),
          );
        },
      ),
    );
  }
}