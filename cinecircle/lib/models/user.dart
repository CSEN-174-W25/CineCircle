/* class User{
    final String userId;
    String username;
    double averageRating;

    User({
        required.this.userId,
        required.this.username,
        this.averageRating
    })

    factory User.fromJson(Map<String, dynamic> json){
        return User(
            userId: json['userId'],
            username: json['username'],
            averageRating:  (json['score'] as num).toDouble()
        );
    }
}
*/