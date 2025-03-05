class Rating {
  final String username;
  final double score;
  String? review;

  Rating({
    required this.username,
    required this.score,
    this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      username: json['username'] ?? "Anonymous", 
      score: (json['score'] as num?)?.toDouble() ?? 0.0, 
      review: json['review'] ?? "", 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "score": score,
      "review": review,
    };
  }
}
