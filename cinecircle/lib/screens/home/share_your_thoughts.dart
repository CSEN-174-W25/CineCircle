import 'package:flutter/material.dart';
import 'package:cinecircle/models/movie.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

class ShareYourThoughts extends StatefulWidget {
  final Movie movie;
  final Function onReviewAdded; // Callback to update FriendActivity

  const ShareYourThoughts({required this.movie, required this.onReviewAdded, super.key});

  @override
  _ShareYourThoughtsState createState() => _ShareYourThoughtsState();
}

class _ShareYourThoughtsState extends State<ShareYourThoughts> {
  final _controller = TextEditingController();
  double _rating = 3.0;

  void _submitReview() {
    if (_controller.text.isEmpty) return;

    Rating newRating = Rating(
      userId: "user123", // Replace with actual user ID later
      title: widget.movie.title,
      score: _rating,
      comment: _controller.text,
    );

    setState(() {
      widget.movie.addRating(newRating); // Update movie ratings
    });

    widget.onReviewAdded(newRating); // Send to FriendActivitySection
    _controller.clear(); // Clear input field
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Share Your Thoughts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
        children: [
          Text("Your Rating:"),
          FivePointedStar(
          onChange: (value) {
            setState(() {
            _rating = value.toDouble();
            });
          },
          ),
        ],
        ),
        TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: "Write a review..."),
        ),
        ElevatedButton(
        onPressed: _submitReview,
        child: Text("Submit"),
        ),
      ],
      ),
    );
  }
}
