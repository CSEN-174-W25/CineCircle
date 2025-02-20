// Displays the user's top 4 favorite movies

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/movie.dart';

class FavoriteMovies extends StatefulWidget{
    final List<Movie> top4;

    @override
   _FavoriteMoviesState createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies>{
    @override
    Widget build (BuildContext context){
        return Row();
    }
}