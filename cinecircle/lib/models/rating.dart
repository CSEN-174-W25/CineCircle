class Rating {
  final String userId;
  final String username;
  final double score;
  String? comment;

  Rating({
    required this.userId, 
    required this.username, 
    required this.score, 
    this.comment
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      username: json['username'],
      score: (json['score'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}
