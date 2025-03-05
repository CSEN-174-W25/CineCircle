//Shows user's 4 most recent watches

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/movie_entry.dart';
import 'package:cinecircle/models/movie.dart';

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
       children: widget.user.watchlist.map((watchlist) { 
        return Row(
          children: [
            Image.network(
              watchlist.movie.imageUrl,
              width: 90, 
              height: 140,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Text(watchlist.movie.title),
                Text('Watched on ${watchlist.watchdate}'),
              ]
            )
          ]);
      }).toList(),
    );
  }
}