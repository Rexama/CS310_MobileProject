class Comment {
  late String username;
  late String content;
  late String? newsId;
  late String? blogId;
  late String commentId;

  Comment(String userId, String content, String newsId, String blogId,  String commentId) {
    this.username = username;
    this.content = content;
    this.newsId = newsId;
    this.blogId = blogId;
    this.commentId = commentId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        content = json['content'],
        newsId = json['newsId'],
        blogId = json['blogId'],
        commentId = json['commentId'];

  Map<String, dynamic> toJson() => {
        'userId': username,
        'content': content,
        'newsId': newsId,
        'blogId': blogId,
        'commentId': commentId,
      };
}
