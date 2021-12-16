class Comment {
  late String userId;
  late String comment;
  late String newsId;
  late String blogId;

  Comment(String userId, String comment, String newsId, String blogId) {
    this.userId = userId;
    this.comment = comment;
    this.newsId = newsId;
    this.blogId = blogId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        comment = json['comment'],
        newsId = json['newsId'],
        blogId = json['blogId'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'comment': comment,
        'newsId': newsId,
        'blogId': blogId,
      };
}
