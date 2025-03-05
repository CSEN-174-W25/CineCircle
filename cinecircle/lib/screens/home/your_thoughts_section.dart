import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/widgets/media_card.dart';
import 'package:cinecircle/models/rating.dart';
import 'package:cinecircle/screens/home/media_review.dart';

final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
const String baseUrl = "https://api.themoviedb.org/3";

class YourThoughtsSection extends StatefulWidget {
  final Media? selectedMedia;
  final Function(Media) onMediaSelected;
  final Function(Media, Rating) onReviewAdded;

  const YourThoughtsSection({
    required this.selectedMedia,
    required this.onMediaSelected,
    required this.onReviewAdded,
    super.key,
  });

  @override
  YourThoughtsSectionState createState() => YourThoughtsSectionState();
}

class YourThoughtsSectionState extends State<YourThoughtsSection> {
  bool isSearching = false;
  List<Media> cachedTrendingMedias = [];
  List<Media> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  Media? selectedMedia;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (apiKey.isEmpty) {
      print("Error: TMDB API key is missing!");
    } else {
      fetchTrendingMedias();
    }
  }

  @override
  void dispose() {
    // Used to pause firebase calls when user is typing to avoid excessive calls
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchTrendingMedias() async {
    if (cachedTrendingMedias.isNotEmpty) return;

    final url = "$baseUrl/trending/all/day?api_key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            cachedTrendingMedias =
                (data["results"] as List).map((item) => Media.fromJson(item)).toList();
          });
        }
      } else {
        throw Exception("Failed to load trending content");
      }
    } catch (error) {
      print("Network error: $error");
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 2000), () {
      if (mounted) {
        searchMoviesAndShows(_searchController.text);
      }
    });
  }

  Future<void> searchMoviesAndShows(String query) async {
    if (query.isEmpty) return;

    final url = "$baseUrl/search/multi?api_key=$apiKey&query=$query";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            searchResults = (data["results"] as List)
                .where((item) => item["poster_path"] != null && item["poster_path"].isNotEmpty)
                .map((item) => Media.fromJson(item))
                .toList();
          });
        }
      } else {
        throw Exception("Failed to load search results");
      }
    } catch (error) {
      print("Network error: $error");
      if (mounted) {
        setState(() {
          searchResults = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error: Please check your internet connection")),
        );
      }
    }
  }

  void onMediaSelected(Media media) {
    if (!mounted) return; // Ensure widget is still in the tree before updating UI

    setState(() {
      if (selectedMedia == media) {
        selectedMedia = null; // Unselect if already selected
      } else {
        selectedMedia = media;
      }
    });

    widget.onMediaSelected(media);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Thoughts",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Trending/Search Toggle Buttons
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isSearching = false;
                          fetchTrendingMedias();
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: !isSearching ? Colors.red : Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Trending",
                          style: TextStyle(
                            color: !isSearching ? Colors.white : Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isSearching = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSearching ? Colors.purple : Colors.purple[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Search",
                          style: TextStyle(
                            color: isSearching ? Colors.white : Colors.purple[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          if (isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for movies & shows...",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchMoviesAndShows(_searchController.text);
                    },
                  ),
                ),
                onChanged: (value) => _onSearchChanged(),
                onSubmitted: (value) {
                  searchMoviesAndShows(value);
                },
              ),
            ),

          SizedBox(height: 10),

          // Show Movie List w/ dynmaic height depending on selected media tab
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: selectedMedia == null ? 380 : 570,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isSearching ? searchResults.length : cachedTrendingMedias.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                Media media = isSearching ? searchResults[index] : cachedTrendingMedias[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      MediaCard(
                        media: media,
                        onTap: () => onMediaSelected(media),
                        imageHeight: 335,
                      ),
                      if (selectedMedia == media)
                        SizedBox(
                          width: 254,
                          child: MediaReview(
                            media: media,
                            onReviewAdded: (Media media, Rating rating) {
                              widget.onReviewAdded(media, rating);
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}