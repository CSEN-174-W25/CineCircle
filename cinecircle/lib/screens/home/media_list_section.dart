import 'package:flutter/material.dart';
import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/rating.dart';
import '../../widgets/media_card.dart';
import 'media_review.dart';

class MediaListSection extends StatelessWidget {
  final List<Media> medias;
  final Media? selectedMedia;
  final Function(Media) onMediaSelected;
  final Function(Media, Rating) onReviewAdded;

  const MediaListSection({
    required this.medias,
    required this.selectedMedia,
    required this.onMediaSelected,
    required this.onReviewAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: medias.map((media) {
        return Column(
          children: [
            MediaCard(
              media: media,
              onTap: () => onMediaSelected(media), // Handle media selection
            ),
            if (selectedMedia == media) // Show FilmReview under selected media
              MediaReview(
                media: media,
                onReviewAdded: (Media media, Rating rating) => onReviewAdded(media, rating),
              ),
          ],
        );
      }).toList(),
    );
  }
}
