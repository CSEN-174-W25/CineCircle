//Displays one of the user's favorite media and allows user to change it

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/widgets/media_card.dart';
import 'package:cinecircle/services/firestore_service.dart';

class InputFav extends StatefulWidget{
  final User user;
  final int index;
  double imageHeight;
  double imageWidth;

  InputFav({
    required this.user,
    required this.index,
    this.imageHeight = 118,
    this.imageWidth = 95.5,
    super.key});

  @override
  _InputFavState createState() => _InputFavState();
}

class _InputFavState extends State<InputFav>{
  String? mediaId;
  //double imageHeight = 118;
  //double imageWidth = 95.5;

  @override
  void initState() {
    super.initState();
    _loadMediaId();
  }

   Future<void> _loadMediaId() async {
    String? fetchedMovieId = await FirestoreService().getFav(widget.user.userId, widget.index);
    if (mounted) {
      setState(() {
        mediaId = fetchedMovieId;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    FirestoreService().ensureFavField(widget.user.userId);

    if (mediaId == null){
      return CircularProgressIndicator();
    }

    if (mediaId == "") {
      return Image.asset(
        "assets/images/placeholder.png",
        width: widget.imageWidth,
        height: widget.imageHeight,
        fit: BoxFit.cover,
      );
    }

    return Text("Lol");
  }
}
/*
  const MediaCard({
    required this.media,
    required this.onTap,
    this.imageHeight = 300,
    this.imageWidth = 255,
    super.key,
  });
*/