import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';

class MediaCard extends StatelessWidget {
  final Media media;
  final VoidCallback onTap;
  final double imageHeight;
  final double imageWidth;

  const MediaCard({
    required this.media,
    required this.onTap,
    this.imageHeight = 300,
    this.imageWidth = 255,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: media.imageUrl.isEmpty || !media.imageUrl.startsWith("http")
                ? Image.asset(
                    "assets/images/placeholder.png",
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    media.imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading image: $error");
                      return Image.asset(
                        "assets/images/placeholder.png",
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          
          // Added width constraint for text wrapping
          SizedBox(height: 5),
          SizedBox(
            width: imageWidth,
            child: Text(
              media.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}