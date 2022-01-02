import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/News.dart';
import 'package:uuid/uuid.dart';
import 'package:week6_starter/models/Users.dart';

class DBService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  Future addUserAutoID(String username, String mail, String token) async {
    List<dynamic> strList = [];
    var uuid = Uuid();
    final String userId = uuid.v4();
    userCollection
        .doc(token)
        .set({
          'userId': userId,
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
    var uuid = Uuid();
    final String userId = uuid.v4();
    userCollection.doc(token).set({
      'userId': userId,
      'username': username,
      'userToken': token,
      'email': mail,
    });
  }

  Future deleteUser(String userId) async {
    firestoreInstance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.delete();
      });
    });

    firestoreInstance
        .collection("blog")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.delete();
      });
    });

    firestoreInstance
        .collection("comment")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.delete();
      });
    });
  }

  Future deactivateUser(String userId, bool newValue) async {
    firestoreInstance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.update({
          'isActive': newValue,
        });
      });
    });

    firestoreInstance
        .collection("blog")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.update({
          'isActive': newValue,
        });
      });
    });

    firestoreInstance
        .collection("comment")
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.update({
          'isActive': newValue,
        });
      });
    });
  }

  Future<Users?> getUser(String userID) async {
    Users? user = null;
    await firestoreInstance
        .collection("users")
        .where('userId', isEqualTo: userID)
        .get()
        .then((querySnapshot) {
      user = Users.fromJson(querySnapshot.docs.first.data());
      print("I received that user from database: " + user!.userName);
    }).catchError((error) => print('Error: ${error.toString()}'));
    return user;
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

  Future getComments(List<Comment> comments, String id, bool isBlog) async {
    comments.clear();
    var type;
    if (isBlog) {
      type = "blogId";
    } else {
      type = "newsId";
    }
    print(id);
    firestoreInstance
        .collection("comment")
        .where(type, isEqualTo: id)
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
        .then((value) => print(allBlogs[0].image as String))
        .catchError((error) => print('Error: ${error.toString()}'));
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

  Future makeAccountPrivate(String token, bool isPrivate) async {
    firestoreInstance.collection("users").doc(token).update({
      'isPriv': isPrivate,
    });
    print("Updated");
  }

  Future addComment(
      String comment, String id, String userId, bool isBlog) async {
    var data;
    var uuid = Uuid();
    final String commentId = uuid.v4();
    if (isBlog) {
      data = {
        'blogId': id,
        'content': comment,
        'isActive': true,
        'newsId': "",
        'userId': userId,
        'commentId': commentId,
      };
    } else {
      data = {
        'blogId': "",
        'content': comment,
        'isActive': true,
        'newsId': id,
        'userId': userId,
        'commentId': commentId,
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
        .orderBy('uploadDate', descending: true)
        .where('userId', isEqualTo: userID)
        .get()
        .then((querySnapshot) {
      Blog tempBlog = Blog.fromJson(querySnapshot.docs.first.data());
      recentUpload = tempBlog.uploadDate;
      print("inside lastBlogDate, recentUpload: " + recentUpload.toString());
    }).catchError((error) => print('Error: ${error.toString()}'));
    return recentUpload;
  }

  Future postBlogItem(String title, String content, String imageUrl,
      List<String> categories, DateTime uploadDate, String userID) async {
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
        'isActive': true,
        'title': title,
        'uploadDate': uploadDate,
        'userId': userID,
      };
      firestoreInstance
          .collection("blog")
          .add(data)
          .then((value) => print('Blog posted by ' + userID))
          .catchError((error) => print('Error: ${error.toString()}'));
    } else {
      throw ("nein nein nein!!! you have already posted once today!!!");
    }
  }

  Future likeCountOperationsByID(
      String userToken, String blogId, int count) async {
    firestoreInstance
        .collection("blog")
        .doc(blogId)
        .set({'numLike': FieldValue.increment(count)});

    firestoreInstance.collection("users").doc(userToken).update({
      'likedNews': FieldValue.arrayUnion([blogId])
    });
  }

  Future dislikeCountOperationsById(
      String userToken, String blogId, int count) async {
    firestoreInstance
        .collection("blog")
        .doc(blogId)
        .set({'numDislike': FieldValue.increment(count)});

    firestoreInstance.collection("users").doc(userToken).update({
      'dislikedNews': FieldValue.arrayUnion([blogId])
    });
  }

  Future getBlogsById(String blogId, List<Blog> blogsById) async {
    firestoreInstance
        .collection("blog")
        .where('blogId', isEqualTo: blogId)
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            Blog tempBlog = Blog.fromJson(result.data());
            blogsById.add(tempBlog);
          });
        })
        .then((value) => print(blogsById[0].image as String))
        .catchError((error) => print('Error: ${error.toString()}'));
  }
}
