import 'media.dart';

class MediaEntry {
  final Media media;
  final DateTime watchdate;
  double? score;

  MediaEntry({
      required this.media,
      required this.watchdate,
      this.score     //Default -1 so that rating invisible when unrated
  });

  factory MediaEntry.fromJson(Map<String, dynamic> json){
    return MediaEntry(
      media: Media.fromJson(json['media']),
      watchdate: DateTime.parse(json['watchdate']),
      score: (json['score'] as num).toDouble()
    );
  }
}

