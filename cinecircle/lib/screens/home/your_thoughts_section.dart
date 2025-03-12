import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/widgets/media_card.dart';

final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
const String baseUrl = "https://api.themoviedb.org/3";

class YourThoughtsSection extends StatefulWidget {
  final Function(Media) onMediaTap;

  const YourThoughtsSection({
    required this.onMediaTap,
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
              "Find Movies and Shows",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),

        SizedBox(height: 10),

        // Add Toggle Buttons for Trending/Search
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching = false;
                      fetchTrendingMedias();
                    });
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
                    setState(() {
                      isSearching = true;
                    });
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

        // Display Media Cards
        Container(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: isSearching ? searchResults.length : cachedTrendingMedias.length,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              Media media = isSearching ? searchResults[index] : cachedTrendingMedias[index];

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: MediaCard(
                  media: media,
                  imageHeight: 335,
                  onTap: () {
                    widget.onMediaTap(media); // Call onMediaTap here
                  },
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