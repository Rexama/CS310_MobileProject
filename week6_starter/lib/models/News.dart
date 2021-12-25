import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  late String newsId;
  late String title;
  late String subtitle;
  late String content;
  late String? image;
  late DateTime uploadDate;
  late List<String> category;
  late List<String> suggestions;
  late List<String> comments;
  late int numLike;
  late int numDislike;

  News(
      String newsId,
      String title,
      String subtitle,
      String content,
      String image,
      DateTime uploadDate,
      List<String> category,
      List<String> suggestions,
      List<String> comments,
      int numLike,
      int numDislike) {
    this.newsId = newsId;
    this.title = title;
    this.subtitle = subtitle;
    this.content = content;
    this.category = category;
    this.image = image;
    this.uploadDate = uploadDate;
    this.suggestions = suggestions;
    this.comments = comments;
    this.numLike = numLike;
    this.numDislike = numDislike;
  }

  News.fromJson(Map<String, dynamic> json)
      : newsId = json['newsId'],
        title = json['title'],
        subtitle = json['subtitle'],
        content = json['content'],
        image = json['image'],
        uploadDate = (json['createdOn'] as Timestamp).toDate(),
        category = List<String>.from(json['category'].map((i) => i.toString())),
        suggestions =
            List<String>.from(json['suggestions'].map((i) => i.toString())),
        comments = List<String>.from(json['comments'].map((i) => i.toString())),
        numLike = json['numLike'],
        numDislike = json['numDislike'];


  Map<String, dynamic> toJson() => {
        'newsId': newsId,
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'image': image,
        'category': category,
        'suggestions': suggestions,
        'comments': comments,
        'numLike': numLike,
        'numDislike': numDislike,
        'createdOn': uploadDate,
      };
}
