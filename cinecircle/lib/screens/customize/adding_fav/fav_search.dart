import 'package:flutter/material.dart'; 
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/services/firestore_service.dart';

class FavSearch extends StatefulWidget{
  final User user;
  final int index;

  FavSearch({
    required this.user,
    required this.index,
    super.key
  });

  @override
  _FavSearchState createState() => _FavSearchState();
}

class _FavSearchState extends State<FavSearch>{
  List<Media> reviewedMedia = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

  Future<void> fetchMedia() async {
    List<Media> media = await FirestoreService().getReviewedMedia(widget.user.userId);
    setState(() {
      reviewedMedia = media;
      isLoading = false;
    });
  }

  Future<void> selectFavMedia(Media media) async {
    await FirestoreService().updateFavMedia(widget.user.userId, widget.index, media.id);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Select Favorite",
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
      body:isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: reviewedMedia.length,
          itemBuilder: (context, index) {
            Media media = reviewedMedia[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0), 
              child: ListTile(
                leading: Image.network(
                  media.imageUrl,
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover
                ),
                title: Text(media.title),
                onTap: () => selectFavMedia(media),
              ),
            );
          }
        )
    );
  }
}