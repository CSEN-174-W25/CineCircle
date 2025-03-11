import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/services/firestore_service.dart';

class FriendActivitySection extends StatelessWidget {
  final void Function(Media) onMediaTap;

  const FriendActivitySection({
    required this.onMediaTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

        StreamBuilder<List<Media>>(
          stream: FirestoreService().getAllFriendMedia(), // Real-time stream
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Error loading reviews."),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No reviews yet."),
              );
            } else {
              final mediaWithReviews = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mediaWithReviews.length,
                itemBuilder: (context, index) {
                  final media = mediaWithReviews[index];

                  return GestureDetector(
                    onTap: () => onMediaTap(media), // Data refresh happens automatically
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
                                  "Total Reviews: ${media.reviewCount}",
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
              );
            }
          },
        ),
      ],
    );
  }
}