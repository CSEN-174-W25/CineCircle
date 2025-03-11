import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FriendRequestButton extends StatefulWidget {
  final String userId;  // ID of the profile being viewed

  const FriendRequestButton({Key? key, required this.userId}) : super(key: key);

  @override
  _FriendRequestButtonState createState() => _FriendRequestButtonState();
}

class _FriendRequestButtonState extends State<FriendRequestButton> {
  String buttonText = "Loading...";
  bool isFriend = false;
  bool isOutgoingRequest = false;
  bool isIncomingRequest = false;
  bool isViewingOwnProfile = false;

  @override
  void initState() {
    super.initState();
    _checkFriendStatus();
  }

  /// Check Firestore for relationship
  Future<void> _checkFriendStatus() async {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    // Check if the profile is the user's own profile
    if (widget.userId == currentUserId) {
      setState(() {
        isViewingOwnProfile = true;
      });
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (userDoc.exists) {
      List<dynamic> friendsList = userDoc['friends'] ?? [];
      List<dynamic> pendingIncoming = userDoc['pendingIncomingFriends'] ?? [];
      List<dynamic> pendingOutgoing = userDoc['pendingOutgoingFriends'] ?? [];

      setState(() {
        isFriend = friendsList.contains(widget.userId);
        isIncomingRequest = pendingIncoming.contains(widget.userId);
        isOutgoingRequest = pendingOutgoing.contains(widget.userId);

        // Set button text accordingly
        if (isFriend) {
          buttonText = "Remove Friend";
        } else if (isOutgoingRequest) {
          buttonText = "Cancel Request";
        } else if (isIncomingRequest) {
          buttonText = "Accept Request";
        } else {
          buttonText = "Add Friend";
        }
      });
    }
  }

  /// Toggle Friend
  Future<void> toggleFriend() async {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null || isViewingOwnProfile) return;

    DocumentReference currentUserRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    DocumentReference viewedUserRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    try {
      if (isFriend) {
        // Remove friend
        await currentUserRef.update({
          'friends': FieldValue.arrayRemove([widget.userId])
        });
        await viewedUserRef.update({
          'friends': FieldValue.arrayRemove([currentUserId])
        });

        setState(() {
          isFriend = false;
          buttonText = "Add Friend";
        });
      } else if (isOutgoingRequest) {
        // Cancel outgoing request
        await currentUserRef.update({
          'pendingOutgoingFriends': FieldValue.arrayRemove([widget.userId])
        });
        await viewedUserRef.update({
          'pendingIncomingFriends': FieldValue.arrayRemove([currentUserId])
        });

        setState(() {
          isOutgoingRequest = false;
          buttonText = "Add Friend";
        });
      } else if (isIncomingRequest) {
        // Accept incoming request
        await currentUserRef.update({
          'friends': FieldValue.arrayUnion([widget.userId]),
          'pendingIncomingFriends': FieldValue.arrayRemove([widget.userId])
        });
        await viewedUserRef.update({
          'friends': FieldValue.arrayUnion([currentUserId]),
          'pendingOutgoingFriends': FieldValue.arrayRemove([currentUserId])
        });

        setState(() {
          isFriend = true;
          buttonText = "Remove Friend";
        });
      } else {
        // Send new friend request
        await currentUserRef.update({
          'pendingOutgoingFriends': FieldValue.arrayUnion([widget.userId])
        });
        await viewedUserRef.update({
          'pendingIncomingFriends': FieldValue.arrayUnion([currentUserId])
        });

        setState(() {
          isOutgoingRequest = true;
          buttonText = "Cancel Request";
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating friend status. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide the button if viewing your own profile
    if (isViewingOwnProfile) {
      return SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: toggleFriend,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFriend
            ? Colors.red  // Remove Friend state
            : isOutgoingRequest
                ? Colors.grey  // Cancel Request state
                : isIncomingRequest
                    ? Colors.green // Accept Request state
                    : Colors.blue, // Add Friend state
      ),
      child: Text(buttonText),
    );
  }
}
