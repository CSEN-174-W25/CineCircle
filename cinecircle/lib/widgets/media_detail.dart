import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/services/firestore_service.dart';

class MediaDetail extends StatefulWidget {
  final Media media;

  const MediaDetail({required this.media, super.key});

  @override
  _MediaDetailState createState() => _MediaDetailState();
}

class _MediaDetailState extends State<MediaDetail> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFriendReviews(); // Fetch data when widget initializes
  }

  Future<void> fetchFriendReviews() async {
    await FirestoreService().getFriendReviewsForMedia(widget.media);
    setState(() {
      isLoading = false; // Trigger UI update after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.media.title)),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // loading circle when movies are populating
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.media.imageUrl), // Show media poster
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${widget.media.title} (${widget.media.mediaType})",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(
                            widget.media.releaseDate,
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(
                            "Average Rating: ${widget.media.averageRating.toStringAsFixed(1)}/5 From ${widget.media.ratings.length} Reviews",
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.media.overview,
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
                  widget.media.ratings.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("No reviews yet."),
                        )
                      : Column(
                          children: widget.media.ratings
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
            ),
    );
  }
}
