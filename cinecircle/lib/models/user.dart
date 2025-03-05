import 'movie.dart';
import 'movie_entry.dart';

class User{
    final String userId;
    String username;
    double averageRating;
    int friendsAmount;
    String picUrl;  //Profile picture URL
    List<Movie> top4;
    String bio;
    int watched;
    List<MovieEntry> watchlist;
    List<String> reviewedMedias; 
    List<String> friends;
    int totalReviews;

    User({
        required this.userId,
        required this.username,
        this.averageRating = 0.0,
        this.friendsAmount = 0,
        required this.picUrl,
        this.watched = 0,
        required this.friends,
        List<Movie>? top4,
        List<MovieEntry>? watchlist,
        required this.reviewedMedias,
        this.totalReviews = 0,
        required this.bio
    }): top4 = top4 ?? [], watchlist = watchlist ?? [];

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            userId: json['userId'],
            username: json['username'],
            averageRating:  (json['score'] as num).toDouble(),
            reviewedMedias: List<String>.from(json['reviewedMedias'] ?? []),
            friends: List<String>.from(json['friends'] ?? []),
            totalReviews: json['totalReviews'] ?? 0,
            friendsAmount: (json['friendsAmount'] as num).toInt(),
            watched: (json['watched'] as num).toInt(),
            picUrl: json['picUrl'] ?? '',
            bio: json['bio'],
            watchlist: (json['watchlist'] as List?)?.map((item) => MovieEntry.fromJson(item)).toList() ?? [],
            top4: (json['top4'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
        ); 
    }

    Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'friendsAmount': friendsAmount,
      'reviewedMedias': reviewedMedias,
      'friends': friends,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
}
}
