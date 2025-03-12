class Rating {
  final String username;
  final String userId;
  final double score;
  String? review;

  Rating({
    required this.username,
    required this.score,
    required this.userId,
    this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      username: json['username'] ?? "Anonymous", 
      score: (json['score'] as num?)?.toDouble() ?? 0.0, 
      review: json['review'] ?? "", 
      userId: json['userId'] ?? "UnknownId",
    );
  }
}
