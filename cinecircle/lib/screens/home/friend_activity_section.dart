import 'package:flutter/material.dart';
import 'package:cinecircle/models/rating.dart';

class FriendActivitySection extends StatefulWidget {
  final List<Rating> reviews;

  const FriendActivitySection({required this.reviews, super.key});

  @override
  _FriendActivitySectionState createState() => _FriendActivitySectionState();
}

class _FriendActivitySectionState extends State<FriendActivitySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Friend Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (widget.reviews.isEmpty)
        Text("No reviews yet.")
        else
        Column(
          children: widget.reviews.map((rating) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
          title: Text("${rating.userId} rated ${rating.title} ${rating.score}/5."),
          subtitle: Text(rating.comment ?? ""),
              ),
            );
          }).toList(),
        )
      ],
      ),
    );
  }
}
