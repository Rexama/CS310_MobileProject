class Comment {
  late String username;
  late String content;
  late String? newsId;
  late String? blogId;

  Comment(String userId, String content, String newsId, String blogId) {
    this.username = username;
    this.content = content;
    this.newsId = newsId;
    this.blogId = blogId;
  }

  Comment.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        content = json['content'],
        newsId = json['newsId'],
        blogId = json['blogId'];

  Map<String, dynamic> toJson() => {
        'userId': username,
        'content': content,
        'newsId': newsId,
        'blogId': blogId,
      };
}
