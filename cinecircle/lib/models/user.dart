import 'movie.dart';
import 'movie_entry.dart';

class User{
    final String userId;
    String username;
    double averageRating;
   // List<User> friendList;
    int friendsAmount;
    String picUrl;  //Profile picture URL
    List<Movie> top4;
    String bio;
    int watched;
    List<MovieEntry> watchlist;

    User({
        required this.userId,
        required this.username,
        this.averageRating = 0.0,
        this.friendsAmount = 0,
        required this.picUrl,
        this.watched = 0,
        List<Movie>? top4,
        List<MovieEntry>? watchlist,
        required this.bio
        //List<User> friendList
    }): top4 = top4 ?? [], watchlist = watchlist ?? [];

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            userId: json['userId'],
            username: json['username'],
            averageRating:  (json['score'] as num).toDouble(),
            friendsAmount: (json['friendsAmount'] as num).toInt(),
            watched: (json['watched'] as num).toInt(),
            picUrl: json['picUrl'] ?? '',
            bio: json['bio'],
            watchlist: (json['watchlist'] as List?)?.map((item) => MovieEntry.fromJson(item)).toList() ?? [],
            top4: (json['top4'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
        ); 
    }
}
