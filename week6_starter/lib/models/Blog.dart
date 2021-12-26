import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  late String blogId;
  late String title;
  late String content;
  late String? image;
  late DateTime uploadDate;
  late List<String>? category;
  late List<String>? comments;
  late String userId;

  Blog(String blogId, String title, DateTime uploadDate, String content, String image,
      List<String> category, List<String> comments, String userId) {
    this.blogId = blogId;
    this.title = title;
    this.uploadDate = uploadDate;
    this.content = content;
    this.category = category;
    this.comments = comments;
    this.image = image;
    this.userId = userId;
  }

  Blog.fromJson(Map<String, dynamic> json)
      : blogId = json['blogId'],
        title = json['title'],
        uploadDate = (json['uploadDate'] as Timestamp).toDate(),
        content = json['content'],
        comments = List<String>.from(json['comments'].map((i) => i.toString())),
        image = json['imageUrl'],
        category =  List<String>.from(json['category'].map((i) => i.toString())),
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'blogId': blogId,
    'title': title,
    'uploadDate': uploadDate,
    'content': content,
    'comments': comments,
    'imageUrl': image,
    'category': category,
    'userId': userId,
  };
}
