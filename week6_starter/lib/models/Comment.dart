class Comment {
  late String userId;
  late String content;
  late String? newsId;
  late String? blogId;

  Comment(String userId, String content, String newsId, String blogId) {
    this.userId = userId;
    this.content = content;
    this.newsId = newsId;
    this.blogId = blogId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        content = json['content'],
        newsId = json['newsId'],
        blogId = json['blogId'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'content': content,
        'newsId': newsId,
        'blogId': blogId,
      };
}
