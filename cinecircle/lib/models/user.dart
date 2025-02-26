import 'movie.dart';

class User{
    final String userId;
    String username;
    double averageRating;
    //List<User> friendList;
    int friendsAmount;
    String picUrl;  //Profile picture URL
    List<Movie> top4;
    String bio;

    User({
        required this.userId,
        required this.username,
        this.averageRating = 0.0,
        this.friendsAmount = 0,
        required this.picUrl,
        List<Movie>? top4,
        required this.bio
        //required this.friendList
    }): top4 = top4 ?? [];

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            userId: json['userId'],
            username: json['username'],
            averageRating:  (json['score'] as num).toDouble(),
            friendsAmount: (json['friendsAmount'] as num).toInt(),
            picUrl: json['picUrl'] ?? '',
            bio: json['bio'],
            top4: (json['top4'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? []
        ); 
    }
}
