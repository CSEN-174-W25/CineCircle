import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';

class FriendActivitySection extends StatelessWidget {
  final List<Rating> reviews;
  final List<Media> medias;
  final void Function(Media) onMediaTap;

  const FriendActivitySection({
    required this.reviews,
    required this.medias,
    required this.onMediaTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaWithReviews = medias.where((media) => media.ratings.isNotEmpty).toList();
    
    final reversedMediaList = List<Media>.from(mediaWithReviews.reversed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Friend Activity",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        if (reversedMediaList.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No reviews yet."),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Uses HomePage scrolling behavior
            itemCount: reversedMediaList.length,
            itemBuilder: (context, index) {
              final media = reversedMediaList[index];
              return GestureDetector(
                onTap: () => onMediaTap(media),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          media.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              media.title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Average Rating: ${media.averageRating.toStringAsFixed(1)}/5",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            Text(
                              "Total Reviews: ${media.ratings.length}",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}