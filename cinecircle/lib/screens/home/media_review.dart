import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

class MediaReview extends StatefulWidget {
  final Media media;
  final Function(Media, Rating) onReviewAdded;

  const MediaReview({required this.media, required this.onReviewAdded, super.key});

  @override
  MediaReviewState createState() => MediaReviewState();
}

class MediaReviewState extends State<MediaReview> {
  final TextEditingController _controller = TextEditingController();
  double _rating = 0.0;
  bool isSubmitting = false;
  double textBoxHeight = 50;
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  /// Retrieve the current user's username from Firestore
  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      setState(() {
        _username = userDoc['username'] ?? "Anonymous";
      });
    }
  }

  void _submitReview() {
    if (_controller.text.isEmpty || isSubmitting || _rating == 0.0 || _username == null) return;

    setState(() {
      isSubmitting = true;
    });

    Rating newRating = Rating(
      username: _username!,
      score: _rating,
      review: _controller.text,
    );

    widget.onReviewAdded(widget.media, newRating);
    _controller.clear();

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isSubmitting = false;
          textBoxHeight = 50;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Share Your Thoughts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            if (_username == null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Loading username...", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),

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

            SizedBox(height: 10),

            // Dynamic textField height (since search bar covers part of searched movies)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              child: SizedBox(
                height: textBoxHeight,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (text) {
                    setState(() {
                      textBoxHeight = (text.split("\n").length * 20.0).clamp(50.0, 200.0);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Write a review...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: isSubmitting || _username == null ? null : _submitReview,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}