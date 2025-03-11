// Displays the user's top 4 favorite movies
import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/widgets/media_card.dart';
import 'package:cinecircle/widgets/media_detail.dart';

class FavoriteMovies extends StatefulWidget {
  final User user;

  const FavoriteMovies({
    required this.user,
    super.key,
  });

  @override
  _FavoriteMoviesState createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  @override
  Widget build(BuildContext context) {
    if (widget.user.topFour.isEmpty) {
      return Center(child: Text("No favorite media available."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300, // Base height for non-wrapped titles
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.user.topFour.length,
            itemBuilder: (context, index) {
              final media = widget.user.topFour[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: MediaCard(
                  media: media,
                  imageHeight: 220, 
                  imageWidth: 140, // Increased width for better text wrapping
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaDetail(media: media),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}