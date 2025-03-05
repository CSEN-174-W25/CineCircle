// Shows the user's average ratings across all the movies they've watched & rated as a 5 star rating graphic

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

class AverageRating extends StatefulWidget{
    final User user;

    const AverageRating({
        required this.user,
        super.key
    });

    @override
    _AverageRatingState createState() => _AverageRatingState();
}

class _AverageRatingState extends State<AverageRating> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/021/664/704/small_2x/gold-star-shotting-gold-star-transparent-gold-bokeh-stars-free-free-png.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 5), 
            Text(
              widget.user.averageRating.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          "Across ${widget.user.watched} movies",
          style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 100, 100, 100)),
        ),
      ],
    );
  }
}
