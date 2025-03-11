import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/services/firestore_service.dart';

class MediaDetail extends StatelessWidget {
  final Media media;

  const MediaDetail({required this.media, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(media.title)),
      body: StreamBuilder<List<Rating>>(
        stream: FirestoreService().getFriendReviewsForMedia(media), // Real-time stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading spinner while data is fetching
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading reviews."));
          }

          final ratings = snapshot.data ?? []; // Use empty list if no reviews found

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(media.imageUrl), // Show media poster
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${media.title} (${media.mediaType})",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          media.releaseDate,
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          "Average Rating: ${media.averageRating.toStringAsFixed(1)}/5 From ${ratings.length} Reviews",
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          media.overview,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                  child: Text(
                    "Reviews:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ratings.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("No reviews yet."),
                      )
                    : Column(
                        children: ratings
                            .map(
                              (rating) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                                child: ListTile(
                                  title: Text("${rating.username} rated ${rating.score}/5."),
                                  subtitle: Text(rating.review ?? ""),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}