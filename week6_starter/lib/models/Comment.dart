class Comment {
  late String commentId;
  late String userId;
  late String content;
  late String? newsId;
  late String? blogId;

  Comment( String commentId,
      String userId, String content, String newsId, String blogId) {
    this.commentId = commentId;
    this.userId = userId;
    this.content = content;
    this.newsId = newsId;
    this.blogId = blogId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : commentId = json['commentId'],
        userId = json['userId'],
        content = json['content'],
        newsId = json['newsId'],
        blogId = json['blogId'];

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'userId': userId,
        'content': content,
        'newsId': newsId,
        'blogId': blogId,
      };
}
