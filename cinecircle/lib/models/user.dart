import 'package:cinecircle/models/media.dart';
import 'package:cinecircle/models/recommended_media.dart';

class User{
  final String userId;
  String username;
  double averageRating;
  List<String> reviewedMedias; 
  List<String> friends;
  int totalFriends;
  int totalReviews;
  List<Media> watchlist = [];
  List<String> topFour = [];
  String picUrl = '';
  String bio = '';
  RecommendedMedia recommendedMedia;
  List<User> pendingIncomingFriends = [];
  List<User> pendingOutgoingFriends = [];

  User({
    required this.userId,
    required this.username,
    required this.totalFriends,
    required this.reviewedMedias,
    required this.friends,
    this.totalReviews = 0,
    this.averageRating = 0.0,
    required this.watchlist,
    required this.topFour,
    this.picUrl = '',
    this.bio = '',
    required this.recommendedMedia,
    required this.pendingOutgoingFriends,
    required this.pendingIncomingFriends,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] ?? '',
    username: json['username'] ?? '',
    totalFriends: (json['totalFriends'] as num?)?.toInt() ?? 0,
    reviewedMedias: List<String>.from(json['reviewedMedias'] ?? []),
    friends: List<String>.from(json['friends'] ?? []),
    averageRating: json['averageRating'] ?? 0.0,
    totalReviews: json['totalReviews'] ?? 0,
    watchlist: [],
    topFour: List<String>.from(json['topFour'] ?? []),
    recommendedMedia: json['recommendedMedia'] != null
        ? RecommendedMedia.fromFirestore(json['recommendedMedia'])
        : RecommendedMedia(
            recommended: Media(
              title: "Unknown", 
              id: 0, 
              imageUrl: "", 
              mediaType: "unknown", 
              overview: "",
              releaseDate: "",
              reviewCount: 0,
              averageRating: 0.0
            ),
            sentById: '',
            sentByUsername: ''
          ), 
    picUrl: json['picUrl'] ?? '',
    bio: json['bio'] ?? '',
    pendingIncomingFriends: [],
    pendingOutgoingFriends: [],
  );
}

    Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'totalFriends': totalFriends,
      'reviewedMedias': reviewedMedias,
      'friends': friends,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'recommendedMedia': recommendedMedia,
      'picUrl': picUrl,
      'bio': bio,
      'pendingIncomingFriends': pendingIncomingFriends,
      'pendingOutgoingFriends': pendingOutgoingFriends,
      'topFour': topFour,
    };
}
}
