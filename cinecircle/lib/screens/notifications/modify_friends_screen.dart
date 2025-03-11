import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinecircle/screens/profile/profile_page.dart';

class ModifyFriendsScreen extends StatefulWidget {
  @override
  _ModifyFriendsScreenState createState() => _ModifyFriendsScreenState();
}

class _ModifyFriendsScreenState extends State<ModifyFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  Set<String> friendsList = {}; // Stores current friends' IDs to compare
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserFriends();
  }

  Future<void> getCurrentUserFriends() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        currentUserId = user.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        if (userDoc.exists) {
          List<dynamic> friends = userDoc['friends'] ?? [];
          setState(() {
            friendsList = Set<String>.from(friends);
          });
        }
      }
    } catch (error) {
      print("Error fetching friends: $error");
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs.map((doc) {
          var data = doc.data();
          data['userId'] = doc.id;
          return data;
        }).toList();
      });
    } catch (error) {
      print("Firebase search error: $error");
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify Friends"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for users...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => searchUsers(value),
              onSubmitted: (value) => searchUsers(value),
            ),
            SizedBox(height: 16),
            Expanded(
              child: searchResults.isEmpty
                ? Center(child: Text("No users found"))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                    final user = searchResults[index];
                    return ListTile(
                      title: Text(user['username'] ?? "Unknown User"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(user['userId']), // Pass user ID to ProfilePage
                            ),
                          );
                        },
                      child: Text("View Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
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