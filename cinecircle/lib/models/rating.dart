class Rating {
  final String userId;
  final String title;
  final double score;
  String? comment;

  Rating({

    required this.userId, 
    required this.title, 
    required this.score, 
    this.comment
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      title: json['title'],
      score: (json['score'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}
