// User Profile Page

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/profile/average_rating.dart';
import 'package:cinecircle/profile/user_description.dart';
import 'package:cinecircle/profile/favorite_movies.dart';

class ProfilePage extends StatefulWidget {
    const ProfilePage({super.key})

    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    void _Friended(User user){
        user.friendsAmount += 1;    // Increases user's friend count
        //Need to add specific user who friended to the friendlist
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("John Doe")),
            body: SingleChildScrollView{
                child: Column(
                    children:[
                        UserDescription(
                            user: user,
                            onFriended: _Friended
                        ),
                        FavoriteMovies(

                        ),
                        AverageRating(
                            user: user
                        )
                    ]
                )
            }
        );
    }
}