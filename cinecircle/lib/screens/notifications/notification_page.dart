import 'package:cinecircle/widgets/media_detail.dart';
import 'package:flutter/material.dart';
import 'modify_friends_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinecircle/models/recommended_media.dart';
import 'package:cinecircle/services/firestore_service.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CineCircle",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter Tight",
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 52, 52),
                Color.fromARGB(255, 194, 0, 161)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [
            // View Profiles Button
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ModifyFriendsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 229, 29, 29), 
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: Text("View Other Profiles"),
              ),
            ),
            SizedBox(height: 20),

            // Notification Container
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 6,
                    )
                  ],
                ),
                child: ListView(
                  children: [
                    // Friend Request Notifications
                    StreamBuilder<List<String>>(
                      stream: FirestoreService().getIncomingFriendRequests(
                        FirebaseAuth.instance.currentUser!.uid
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final requests = snapshot.data ?? [];
                        if (requests.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("No incoming friend requests."),
                          );
                        }

                        return Column(
                          children: requests.map((userId) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox.shrink();
                              }

                              final username = snapshot.data != null ? snapshot.data!['username'] ?? 'Unknown User' : 'Unknown User';

                              return buildNotificationCard(
                                "$username sent you a friend request",
                                onAccept: () => _acceptFriendRequest(userId),
                                onReject: () => _rejectFriendRequest(userId),
                              );
                            },
                          );
                        }).toList(),
                        );
                      },
                    ),

                    // Recommended Media Notifications
                    StreamBuilder<List<RecommendedMedia>>(
                      stream: FirestoreService().getRecommendedMedia(
                        FirebaseAuth.instance.currentUser!.uid
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final recommendedMedia = snapshot.data ?? [];
                        if (recommendedMedia.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("No new tv or movie recommendations."),
                          );
                        }

                        return Column(
                          children: recommendedMedia.map((recommendation) =>
                              buildMediaNotificationCard(recommendation)).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Friend Request Notification Card
  Widget buildNotificationCard(String message,
      {required VoidCallback onAccept, required VoidCallback onReject}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      child: ListTile(
        title: Text(message),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onAccept,
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: onReject,
            ),
          ],
        ),
      ),
    );
  }

  // Media Recommendation Notification Card
Widget buildMediaNotificationCard(RecommendedMedia recommendation) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 6),
    elevation: 3,
    child: ListTile(
      title: Text("${recommendation.sentByUsername} recommended '${recommendation.recommended.title}'"),
      trailing: Icon(Icons.arrow_forward, color: Colors.blue),
      onTap: () async {
        // Navigate to MediaDetailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaDetail(media: recommendation.recommended),
          ),
        );

        // Remove the recommendation from Firestore
        await FirestoreService().removeRecommendedMedia(
          FirebaseAuth.instance.currentUser!.uid,
          recommendation
        );
      },
    ),
  );
}

  // Accept Friend Request Logic
  Future<void> _acceptFriendRequest(String userId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final otherUserRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await currentUserRef.update({
        'friends': FieldValue.arrayUnion([userId]),
        'pendingIncomingFriends': FieldValue.arrayRemove([userId]),
      });

      await otherUserRef.update({
        'friends': FieldValue.arrayUnion([currentUserId]),
        'pendingOutgoingFriends': FieldValue.arrayRemove([currentUserId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Friend request accepted!")),
      );
    } catch (error) {
      print("Error accepting friend request: $error");
    }
  }

  // Reject Friend Request Logic
  Future<void> _rejectFriendRequest(String userId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      final currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);

      await currentUserRef.update({
        'pendingIncomingFriends': FieldValue.arrayRemove([userId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Friend request rejected.")),
      );
    } catch (error) {
      print("Error rejecting friend request: $error");
    }
  }
}