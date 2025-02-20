class Rating {
  final String userId;
  final double score;
  String? comment;

  Rating({
    required this.userId, 
    required this.score, 
    this.comment
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      score: (json['score'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}
