class User{
  final String userId;
  String username;
  double averageRating;
  List<String> reviewedMedias; 
  List<String> friends;
  int totalFriends;
  int totalReviews;

  User({
    required this.userId,
    required this.username,
    required this.totalFriends,
    required this.reviewedMedias,
    required this.friends,
    this.totalReviews = 0,
    this.averageRating = 0.0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      totalFriends: (json['totalFriends'] as num).toInt(),
      reviewedMedias: List<String>.from(json['reviewedMedias'] ?? []),
      friends: List<String>.from(json['friends'] ?? []),
      averageRating: json['averageRating'] ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
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
    };
  }
}