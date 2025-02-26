/* class User{
    final String userId;
    String username;
    double averageRating;
    //List<User> friendList;
    int friendsAmount;

    User({
        required this.userId,
        required this.username,
        required this.averageRating,
        required this.friendsAmount,
        //required this.friendList
    });

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            userId: json['userId'],
            username: json['username'],
            averageRating:  (json['score'] as num).toDouble(),
            friendsAmount: (json['friendsAmount'] as num).toInt(),
        ); 
    }
}