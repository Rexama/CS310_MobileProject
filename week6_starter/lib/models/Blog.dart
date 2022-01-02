import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  late String blogId;
  late String title;
  late String content;
  late String? image;
  late bool isActive;
  late DateTime uploadDate;
  late List<String>? category;
  late List<String>? comments;
  late String userId;

  Blog(String blogId, String title, DateTime uploadDate, String content, String image, List<String> category,
      bool isActive, String userId) {
    this.blogId = blogId;
    this.title = title;
    this.uploadDate = uploadDate;
    this.content = content;
    this.category = category;
    this.image = image;
    this.isActive = isActive;
    this.userId = userId;
  }

  Blog.fromJson(Map<String, dynamic> json)
      : blogId = json['blogId'],
        title = json['title'],
        uploadDate = (json['uploadDate'] as Timestamp).toDate(),
        content = json['content'],
        image = json['image'],
        isActive = json['isActive'],
        category = List<String>.from(json['category'].map((i) => i.toString())),
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'blogId': blogId,
        'title': title,
        'uploadDate': uploadDate,
        'content': content,
        'comments': comments,
        'image': image,
        'isActive': isActive,
        'category': category,
        'userId': userId,
      };
}
