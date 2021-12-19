class Blog {
  late String title;
  late String content;
  late String? image;
  late DateTime uploadDate;
  late List<String>? category;
  late List<String>? comments;
  late String userId;

  Blog(String title, DateTime date, String content, String image,
      List<String> category, List<String> comments, String userId) {
    this.title = title;
    this.uploadDate = date;
    this.content = content;
    this.category = category;
    this.comments = comments;
    this.image = image;
    this.userId = userId;
  }

  Blog.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        uploadDate = json['date'],
        content = json['content'],
        comments = json['comments'],
        image = json['imageUrl'],
        category = json['category'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': uploadDate,
    'content': content,
    'comments': comments,
    'imageUrl': image,
    'category': category,
    'userId': userId,
  };
}
