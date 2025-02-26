import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';

class MediaCard extends StatelessWidget {
  final Media media;
  final VoidCallback onTap;
  final double imageHeight;

  const MediaCard({required this.media, required this.onTap, this.imageHeight = 300, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: media.imageUrl.startsWith("assets/")
                ? Image.asset(
                    media.imageUrl,
                    width: 255,
                    height: imageHeight,
                    fit: BoxFit.cover, // Prevents stretching
                  )
                : Image.network(
                    media.imageUrl,
                    width: 255,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/placeholder.png",
                          width: 255, height: imageHeight, fit: BoxFit.cover);
                    },
                  ),
          ),
          SizedBox(height: 5),
          Text(
            media.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}