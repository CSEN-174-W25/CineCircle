import 'package:flutter/material.dart';

class FriendRequestButton extends StatefulWidget {
  @override
  _FriendRequestButtonState createState() => _FriendRequestButtonState();
}

class _FriendRequestButtonState extends State<FriendRequestButton> {
  String buttonText = "Add Friend";
  bool isRequested = false;

  void handleRequest() {
    setState(() {
      if (!isRequested) {
        buttonText = "Cancel Request";
        isRequested = true;
      } else {
        buttonText = "Add Friend";
        isRequested = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handleRequest,
      style: ElevatedButton.styleFrom(
        backgroundColor: isRequested ? Colors.grey : Colors.blue,
      ),
      child: Text(buttonText),
    );
  }
}