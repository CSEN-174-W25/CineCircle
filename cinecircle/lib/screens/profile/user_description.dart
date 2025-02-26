//Shows number of user's friends and has the follow button. (Maybe add user's friendlist?)

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

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
          backgroundImage: NetworkImage(widget.user.picUrl),
        ),
        const SizedBox(height: 8),
        Text(
          widget.user.username,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.user.friendsAmount} Friends',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          widget.user.bio,
          style: const TextStyle(fontSize: 13)
        )
      ],
    );
  }
}