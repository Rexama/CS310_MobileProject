class Comment {
  late String userId;
  late String content;
  late bool isActive;
  late String? newsId;
  late String? blogId;
  late String commentId;

  Comment(String userId, String content, bool isActive, String newsId, String blogId, String commentId) {
    this.userId = userId;
    this.content = content;
    this.isActive = isActive;
    this.newsId = newsId;
    this.blogId = blogId;
    this.commentId = commentId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        content = json['content'],
        isActive = json['isActive'],
        newsId = json['newsId'],
        blogId = json['blogId'],
        commentId = json['commentId'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'content': content,
        'isActive': isActive,
        'newsId': newsId,
        'blogId': blogId,
        'commentId': commentId,
      };
}
