import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/profile/friend_button.dart';

class UserDescription extends StatefulWidget{
    final User user;

    UserDescription ({
      required this.user,
      super.key
    });

    @override
    _UserDescriptionState createState() => _UserDescriptionState();
}

class _UserDescriptionState extends State<UserDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          //TODO: figure out why this causes exception - backgroundImage: NetworkImage(widget.user.picUrl),
        ),
        const SizedBox(height: 8),
        Text(
          widget.user.username,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.user.totalFriends} Friends',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        FriendRequestButton(userId: widget.user.userId),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0), 
          child: Text(
            widget.user.bio,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}