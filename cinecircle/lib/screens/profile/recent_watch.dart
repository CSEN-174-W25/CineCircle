//Shows user's 4 most recent watches

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

class RecentWatch extends StatefulWidget{
  final User user;

  const RecentWatch({
    required this.user,
    super.key
  });

  @override
  _RecentWatchState createState() => _RecentWatchState();
}

class _RecentWatchState extends State<RecentWatch>{
  @override
  Widget build(BuildContext context){
    return Column(
       children: widget.user.watchlist.map((watchlist) { // Iterate over top4 movies
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Image.network(
            watchlist.movie.imageUrl,
            width: 90, // Set a fixed width
            height: 140, // Set a fixed height
            fit: BoxFit.cover, // Ensure the image fits well
          ),
        );
      }).toList(),
    );
  }
}