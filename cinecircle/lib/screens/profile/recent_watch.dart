import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/widgets/media_card.dart';
import 'package:cinecircle/widgets/media_detail.dart';

class RecentWatch extends StatefulWidget {
  final User user;

  const RecentWatch({
    required this.user,
    super.key
  });

    @override
   _RecentWatchState createState() => _RecentWatchState();
}

class _RecentWatchState extends State<RecentWatch> {
  @override
  Widget build(BuildContext context) {
    if (widget.user.watchlist.isEmpty) {
      return Center(child: Text("No watched films available."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300, // Base height for non-wrapped titles
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.user.watchlist.length,
            itemBuilder: (context, index) {
              final media = widget.user.watchlist[index];

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