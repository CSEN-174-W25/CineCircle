import 'package:flutter/material.dart';
import 'package:cinecircle/screens/home/your_thoughts_section.dart';
import 'package:cinecircle/screens/home/friend_activity_section.dart';
import 'package:cinecircle/screens/notifications/notification_page.dart';
import 'package:cinecircle/screens/profile/profile_page.dart';
import 'package:cinecircle/widgets/media_detail.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinecircle/screens/signin/login_screen.dart';
import 'package:cinecircle/models/user.dart' as model;

class HomePage extends StatefulWidget {
  final model.User user;
  const HomePage({super.key, required this.user});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Media? selectedMedia;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            YourThoughtsSection(
              selectedMedia: selectedMedia,
              onMediaSelected: (Media media) {
                setState(() {
                  selectedMedia = media;
                });
              },
              onReviewAdded: (Media media, Rating rating) {
                    FirestoreService().saveReview(reviewedMedia: media, userReview: rating);
                setState(() {         // Unselect media after review submission
                  selectedMedia = null;
                });
              },
            ),

            SizedBox(height: 20),

            FriendActivitySection(
              onMediaTap: (Media media) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaDetail(media: media),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      NotificationPage(),
      ProfilePage(FirebaseAuth.instance.currentUser?.uid),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                "CineCircle",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter Tight",
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
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
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies & Shows"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}