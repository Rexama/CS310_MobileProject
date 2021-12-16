class News {
  late String newsId;
  late String title;
  late String subtitle;
  late String content;
  late String image;
  late String category;

  News(String Id, String title, String subtitle, String content, String image,
      String category) {
    this.newsId = Id;
    this.title = title;
    this.subtitle = subtitle;
    this.content = content;
    this.category = category;
    this.image = image;
  }

  News.fromJson(Map<String, dynamic> json)
      : newsId = json['id'],
        title = json['title'],
        subtitle = json['subtitle'],
        content = json['content'],
        image = json['imageUrl'],
        category = json['category'];

  Map<String, dynamic> toJson() => {
    'id': newsId,
    'title': title,
    'subtitle': subtitle,
    'content': content,
    'imageUrl': image,
    'category': category,
  };
}
