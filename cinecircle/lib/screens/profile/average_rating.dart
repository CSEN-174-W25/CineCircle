// Shows the user's average ratings across all the movies they've watched & rated as a 5 star rating graphic

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

class AverageRating extends StatefulWidget{
  /*
    final User user;

    const AverageRating({
        required this.user,
        super.key
    });
  */

    @override
    _AverageRatingState createState() => _AverageRatingState();
}

class _AverageRatingState extends State<AverageRating>{
    @override
    Widget build(BuildContext build){
      return Row(
        children: [
          Text("Average User Rating:"),
          FivePointedStar(
            //User Rating from int to star
          )
        ]
      );
    }
}