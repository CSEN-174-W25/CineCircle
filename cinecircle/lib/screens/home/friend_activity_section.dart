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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Friend Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (widget.reviews.isEmpty)
          Text("No reviews yet.")
        else
          Column(
            children: widget.reviews.map((rating) {
              return ListTile(
                title: Text("${rating.username} rated ${rating.score}/5"),
                subtitle: Text(rating.comment ?? ""),
              );
            }).toList(),
          ),
      ],
    );
  }
}
