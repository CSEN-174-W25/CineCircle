class Rating {
  final String userId;
  final double score;
  String? review;

  Rating({
    required this.userId, 
    required this.score, 
    this.review
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      score: (json['score'] as num).toDouble(),
      review: json['review'],
    );
  }
  // Convert to JSON For Storing in Firebase
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "score": score,
      "review": review,
    };
  }
}