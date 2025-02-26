import 'package:flutter/material.dart';
import 'package:cinecircle/screens/home/your_thoughts_section.dart';
import 'package:cinecircle/screens/home/friend_activity_section.dart';
import 'package:cinecircle/screens/notifications/notification_page.dart';
import 'package:cinecircle/screens/profile/profile_page.dart';
import 'package:cinecircle/widgets/media_detail.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Media? selectedMedia;
  List<Media> medias = [];
  List<Rating> friendReviews = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleReviewAdded(Media media, Rating rating) {
    setState(() {
      media.addRating(rating); 

      // Ensure media is added only once
      if (!medias.contains(media)) {
        medias.add(media);
      }

      // Prevent duplicate reviews
      bool isDuplicate = friendReviews.any((r) =>
          r.userId == rating.userId && r.review == rating.review && r.score == rating.score);
      if (!isDuplicate) {
        friendReviews.add(rating);
      }
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
                _handleReviewAdded(media, rating);

                // Unselect media after review submission
                setState(() {
                  selectedMedia = null;
                });
              },
            ),

            SizedBox(height: 20),

            FriendActivitySection(
              reviews: friendReviews,
              medias: medias, 
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
      ProfilePage(),
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
