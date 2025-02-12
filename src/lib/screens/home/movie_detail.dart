import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../models/rating.dart';
// import '../../services/api_service.dart'; TODO: add API

class MovieDetail extends StatefulWidget {
  final Movie movie;

  const MovieDetail({super.key, required this.movie});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final TextEditingController commentController = TextEditingController();
  double userRating = 1.0;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void submitRating(BuildContext context) async {
    if (!mounted) return;
    widget.movie.ratings.add(Rating(
      userId: "user123",
      username: "TestUser",
      score: userRating,
      comment: commentController.text,
    ));

    //TODO: Add rating to API
    // await ApiService.submitRating(widget.movie.id, rating); TODO: Submit from js

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rating submitted!")),
    );

    commentController.clear();
    setState(() {
      userRating = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.movie.imageUrl, width: 200, fit: BoxFit.cover),
            Text("Rate this movie:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Slider(
              value: userRating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: userRating.toString(),
              onChanged: (newRating) {
                setState(() {
                  userRating = newRating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Leave a comment (optional)",
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitRating(context);
              },
              child: Text("Submit Rating"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.movie.ratings.length,
                itemBuilder: (context, index) {
                  final rating = widget.movie.ratings[index];
                  return ListTile(
                    title: Text(rating.username),
                    subtitle: Text(rating.comment ?? ''),
                    trailing: Text(rating.score.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}