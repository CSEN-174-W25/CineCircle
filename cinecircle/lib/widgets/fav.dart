//Displays one of the user's favorite media and allows user to change it

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/widgets/media_card.dart';
import 'package:cinecircle/widgets/media_detail.dart';
import 'package:cinecircle/services/firestore_service.dart';
import 'package:cinecircle/screens/customize/adding_fav/fav_search.dart';

class Fav extends StatefulWidget{
  final User user;
  final int index;
  double imageHeight;
  double imageWidth;
  Media? media;

  Fav({
    required this.user,
    required this.index,
    this.imageHeight = 118,
    this.imageWidth = 95.5,
    this.media,
    super.key});

  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav>{
  String? mediaId;
  Media? media;

  @override
  void initState() {
    super.initState();
    _loadMediaId();
  }

  Future<void> _loadMediaId() async {
    String? fetchedMediaId = await FirestoreService().getFav(widget.user.userId, widget.index);
    if (fetchedMediaId != null && fetchedMediaId.isNotEmpty) {
      Media? fetchedMedia = await FirestoreService().fetchMedia(fetchedMediaId);
      if (mounted) {
        setState(() {
          mediaId = fetchedMediaId;
          media = fetchedMedia;
        });
      }
    }
    else {
      if (mounted) {
        setState(() {
          mediaId = fetchedMediaId;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    FirestoreService().ensureFavField(widget.user.userId);

    if (mediaId == null){
      return CircularProgressIndicator();
    }

    if (mediaId == "") {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/placeholder.png",
              width: widget.imageWidth,
              height: widget.imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: widget.imageWidth,
            child: Text(
              "No Media Selected",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ]
      );
    }

    return MediaCard(
      media: media!,
      imageHeight: widget.imageHeight,
      imageWidth: widget.imageWidth,
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => FavSearch(user: widget.user, index: widget.index), 
          ),
        );
      },
    );
  }
}

