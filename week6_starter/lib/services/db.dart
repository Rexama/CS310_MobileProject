import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/News.dart';

class DBService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  Future addUserAutoID(String username, String mail, String token) async {
    List<dynamic> strList = [];
    userCollection
        .doc(token)
        .set({
          'userId': token,
          'username': username,

          'userToken': token,
          'email': mail,
          'isActive': true,
          'isPriv': false,
          'image':
              "https://www.tutorsvalley.com/public/storage/uploads/tutor/1574383712-1AB5217C-5A13-4888-A5A1-BE0BCADBC655.png",
          'userBio': "",
          'numOfArticles': 0,
          'likedNews': strList,
          'numScience': 0,
          'numFinance': 0,
          'numSports': 0,
          'numHist': 0,
          'numMagazine': 0,
        })
        .then((value) => print('User added'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addUser(String username, String mail, String token) async {
    userCollection.doc(token).set({
      'username': username,
      'userToken': token,
      'email': mail,
    });
  }

  Future getNews(List<News> allNews) async {
    firestoreInstance.collection("news").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        News tempNew = News.fromJson(result.data());
        allNews.add(tempNew);
      });
    });
    return allNews;
  }

  /*Future getComments(List<Comment> comments) async {
    firestoreInstance.collection("comment").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Comment tempComment = Comment.fromJson(result.data());
        comments.add(tempComment);
        print(comments[0].content);
      });
    });
    return comments;
  }*/

  Future getComments(List<Comment> comments, String id, bool isBlog) async {
    var id_type;
    if (isBlog) {
      id_type = "blogId";
    } else {
      id_type = "newsId";
    }
    print(id);
    firestoreInstance
        .collection("comment")
        .where('newsId', isEqualTo: id)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Comment tempComment = Comment.fromJson(result.data());
        comments.add(tempComment);
        print(comments);
      });
    });
    return comments;
  }

  Future getBlogs(List<Blog> allBlogs) async {
    firestoreInstance
        .collection("blog")
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            Blog tempBlog = Blog.fromJson(result.data());
            allBlogs.add(tempBlog);
          });
        })
        .then((value) => print('Comment get'))
        .catchError((error) => print('Error: ${error.toString()}'));
    ;
  }

  Future updateProfile(
      String username, String userBio, String email, String token) async {
    firestoreInstance.collection("users").doc(token).update({
      'username': username,
      'userBio': userBio,
      'email': email,
    });
    print("Updated");
  }

  Future addComment(
      String comment, String username, String id, bool isBlog) async {
    var data;
    if (isBlog) {
      data = {
        'blogId': id,
        'username': username,
        'content': comment,
        'newsId': "",
        'userId': "1",
      };
    } else {
      data = {
        'blogId': "",
        'username': username,
        'content': comment,
        'newsId': id,
      };
      firestoreInstance
          .collection("comment")
          .add(data)
          .then((value) => print('User added'))
          .catchError((error) => print('Error: ${error.toString()}'));
    }
  }
}
