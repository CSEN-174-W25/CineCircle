import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';

class MediaDetail extends StatelessWidget {
  final Media media;

  const MediaDetail({required this.media, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(media.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(media.imageUrl), // Show media poster
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${media.title} (${media.year})",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Average Rating: ${media.averageRating.toStringAsFixed(1)}/5",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  Text(
                    "Total Reviews: ${media.ratings.length}",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 4.0),
              child: Text(
                "Reviews:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: media.ratings.map((rating) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                child: ListTile(
                  title: Text("${rating.userId} rated ${rating.score}/5."),
                  subtitle: Text(rating.review ?? ""),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
