import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/News.dart';
import 'package:uuid/uuid.dart';

class DBService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
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

  Future getNewsCat(List<News> allNews, String cat) async {
    firestoreInstance.collection("news").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        News tempNew = News.fromJson(result.data());
        //print(tempNew.category.toString());
        //print(tempNew.category[0].toString());

        for (int i = 0; i < tempNew.category.length; i++) {
          if (tempNew.category[i] == cat) {
            print(tempNew.category[i].toString());
            allNews.add(tempNew);
          }
        }
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
    var type;
    if (isBlog) {
      type = "blogId";
    } else {
      type = "newsId";
    }
    print(id);
    firestoreInstance.collection("comment").where('newsId', isEqualTo: id).get().then((querySnapshot) {
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
        .then((value) => print(allBlogs[0].image as String))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future updateProfile(String username, String userBio, String email, String token) async {
    firestoreInstance.collection("users").doc(token).update({
      'username': username,
      'userBio': userBio,
      'email': email,
    });
    print("Updated");
  }

  Future addComment(String comment, String username, String id, bool isBlog) async {
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
  
  Future<DateTime>? lastBlogDate(String userID) async {
    DateTime recentUpload = new DateTime(2021);
    await firestoreInstance
        .collection("blog")
        .where('userId', isEqualTo: userID)
        .get()
        .then((querySnapshot) {
            Blog tempBlog = Blog.fromJson(querySnapshot.docs.first.data());
            recentUpload = tempBlog.uploadDate;
            print("inside lastBlogDate, recentUpload: " + recentUpload.toString());
          })
        .catchError((error) => print('Error: ${error.toString()}'));
    return recentUpload;
  }

  Future postBlogItem(String title, String content, String imageUrl, List<String> categories, DateTime uploadDate,
      String userID) async {
    var data;
    var uuid = Uuid();
    final String blogID = uuid.v4();
    DateTime recentUpload = await lastBlogDate(userID) as DateTime;
    //print("inside postBlogItem, lastBlogDate: " + recentUpload.toString());
    //print("inside postBlogItem, lastBlogDate+1day: " + recentUpload.add(Duration(days: 1)).toString());
    //print("inside postBlogItem, uploadDate: " + uploadDate.toString());
    if (recentUpload.add(Duration(days: 1)).isBefore(uploadDate)) {
      data = {
        'blogId': blogID,
        'category': categories,
        'content': content,
        'image': imageUrl,
        'title': title,
        'uploadDate': uploadDate,
        'userId': userID,
      };
      firestoreInstance
          .collection("blog")
          .add(data)
          .then((value) => print('Blog posted by ' + userID))
          .catchError((error) => print('Error: ${error.toString()}'));
    }
    else {
      throw("nein nein nein!!! you have already posted once today!!!");
    }
  }
}
