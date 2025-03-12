import 'package:cinecircle/models/recommended_media.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/services/firestore_service.dart';
import 'package:five_pointed_star/five_pointed_star.dart';

class MediaDetail extends StatefulWidget {
  final Media media;

  const MediaDetail({required this.media, super.key});

  @override
  _MediaDetailState createState() => _MediaDetailState();
}

class _MediaDetailState extends State<MediaDetail> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  String? _username;
  String? _userId;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  /// Retrieve the current user's username from Firestore
  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _username = userDoc['username'] ?? "Anonymous";
        _userId = user.uid;
      });
    }
  }

  /// Submit the Review to Firestore
  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty ||
        isSubmitting ||
        _rating == 0.0 ||
        _username == null ||
        _userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please add a rating and review before submitting.")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    Rating newRating = Rating(
      username: _username!,
      score: _rating,
      userId: _userId!,
      review: _reviewController.text,
    );

    await FirestoreService().saveReview(
      reviewedMedia: widget.media,
      userReview: newRating,
    );

    _reviewController.clear();

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Review submitted successfully!")),
    );
  }

  // Recommends Media to Selected Friend
  Future<void> _recommendMediaToFriend(String friendId) async {
    RecommendedMedia newRecommendation = RecommendedMedia(
      recommended: widget.media,
      sentById: _userId!,
      sentByUsername: _username!,
    );

    await FirestoreService().recommendMedia(
      userId: friendId,
      recommendedMedia: newRecommendation,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Media recommended successfully!")),
    );
  }

  // Show Friend List Dialog
  Future<void> _showFriendListDialog() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    List<String> friendIds = List<String>.from(userDoc['friends'] ?? []);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select a Friend"),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: friendIds.length,
            itemBuilder: (context, index) {
              final friendId = friendIds[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(friendId)
                    .get(),
                builder: (context, friendSnapshot) {
                  if (!friendSnapshot.hasData) return SizedBox.shrink();

                  final friendName =
                      friendSnapshot.data?['username'] ?? 'Unknown User';

                  return ListTile(
                    title: Text(friendName),
                    trailing: Icon(Icons.send, color: Colors.blue),
                    onTap: () {
                      _recommendMediaToFriend(friendId);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.media.title)),
      body: StreamBuilder<List<Rating>>(
        stream: FirestoreService()
            .getFriendReviewsForMedia(widget.media), // Real-time stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading reviews."));
          }

          final ratings = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.media.imageUrl),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(top: 0.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(31, 100, 185, 255),
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.media.title} (${widget.media.mediaType})",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.media.releaseDate,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 97, 97, 97)),
                            ),
                            SizedBox(height: 1),
                            Text(
                              "Average Rating: ${widget.media.averageRating.toStringAsFixed(1)}/5 From ${ratings.length} Reviews",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 97, 97, 97)),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(0, 255, 210, 158),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.media.overview,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 60, 72, 133)),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rate this media:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.send, color: Colors.blue, size: 28),
                            onPressed: _showFriendListDialog,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Star Rating
                      Center(
                        child: FivePointedStar(
                          onChange: (value) {
                            _rating = value.toDouble();
                          },
                        ),
                      ),

                      Divider(thickness: 1, height: 30),

                      TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Write a review...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),

                      SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submitReview,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 49, 120, 201),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isSubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Submit Review",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                  child: Text(
                    "Reviews:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ratings.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("No reviews yet."),
                      )
                    : Column(
                        children: ratings
                            .map(
                              (rating) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 4.0),
                                child: ListTile(
                                  title: Text(
                                      "${rating.username} rated ${rating.score}/5."),
                                  subtitle: Text(rating.review ?? ""),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}