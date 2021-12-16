class Blog {
  late String blogId;
  late String title;
  late String content;
  late String image;
  late DateTime uploadDate;
  late String category;
  late String userId;

  Blog(String Id, String title, DateTime date, String content, String image,
      String category, String userId) {
    this.blogId = Id;
    this.title = title;
    this.uploadDate = date;
    this.content = content;
    this.category = category;
    this.image = image;
    this.userId = userId;
  }

  Blog.fromJson(Map<String, dynamic> json)
      : blogId = json['id'],
        title = json['title'],
        uploadDate = json['date'],
        content = json['content'],
        image = json['imageUrl'],
        category = json['category'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'id': blogId,
    'title': title,
    'date': uploadDate,
    'content': content,
    'imageUrl': image,
    'category': category,
    'userId': userId,
  };
}
