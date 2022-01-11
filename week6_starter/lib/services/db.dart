import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/News.dart';
import 'package:uuid/uuid.dart';
import 'package:week6_starter/models/Users.dart';
import 'dart:math';

class DBService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  Future addUserAutoID(String username, String mail, String token) async {
    List<String> strList = [];
    List<String> strListt = [];
    List<String> strListtt = [];
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
          'dislikedNews': strListt,
          'numScience': 0,
          'numFinance': 0,
          'numSports': 0,
          'numHist': 0,
          'numMagazine': 0,
          'visitedNews': strListtt
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

  Future<Users?> getUserByUid(String userID) async {
    Users? user = null;
    await firestoreInstance
        .collection("users")
        .where('userToken', isEqualTo: userID)
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
            allNews.add(tempNew);
          }
        }
      });
    });
    return allNews;
  }

  Future getRelNews(
      List<News> relatedNews, List<String> cats, String id) async {
    relatedNews.clear();

    print(cats[0]);
    print(cats[1]);
    firestoreInstance
        .collection("news")
        .where("category", arrayContainsAny: cats)
        //.where("newsId", isNotEqualTo: id)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        News tempNew = News.fromJson(result.data());
        if (tempNew.newsId != id) {
          relatedNews.add(tempNew);
          print("relatednews: " + tempNew.title);
        }
      });
    });
    return relatedNews;
  }

  Future getUserOnEmail(String email, Users myUser) async
  {
    //myUser.clear();
    firestoreInstance
        .collection("users")
        .where("email", isEqualTo: email)
        //.where("isActive", isEqualTo: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Users tmpUser = Users.fromJson(result.data());
        myUser = tmpUser;
      });
    });
    return myUser;
  }

  Future getRelNewsOnLike(List<News> relatedNews, Users myUser) async {
    relatedNews.clear();

    String cat = "Sports";//default category
    int largest = [myUser.numScience,myUser.numFinance,myUser.numHist,myUser.numMagazine,myUser.numSports].reduce(max);

    if(largest == myUser.numScience) {cat = "Science";}
    else if(largest == myUser.numFinance) {cat = "Finance";}
    else if(largest == myUser.numHist) {cat = "History";}
    else if(largest == myUser.numMagazine) {cat = "Magazine";}
    else {cat = "Sports";}

    firestoreInstance
        .collection("news")
        .where("category", isEqualTo: cat)
        //.where("newsId", isNotEqualTo: id)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        News tempNew = News.fromJson(result.data());
        relatedNews.add(tempNew);
        print("relatednews based on like, category: "+ cat + "news title: " + tempNew.title);
      });
    });
    return relatedNews;
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
    print("Profile Updated");
  }

  Future updateImage(String imageURL, String token) async {
    print(imageURL);
    firestoreInstance.collection("users").doc(token).update({
      'image': imageURL,
    });
    print("Image Updated");
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
    }
    firestoreInstance
        .collection("comment")
        .add(data)
        .then((value) => print('User added'))
        .catchError((error) => print('Error: ${error.toString()}'));
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

  _updateAllFromCollection(CollectionReference collection, String docName,
      String fieldName, String newsId, FieldValue val) async {
    DocumentReference docRef;
    print("update");
    var response = await collection.where(docName, isEqualTo: newsId).get();
    var batch = FirebaseFirestore.instance.batch();
    response.docs.forEach((doc) {
      docRef = collection.doc(doc.id);
      batch.update(docRef, {fieldName: val});
      print("---");
      print(val);
      print("---");
    });
    batch.commit().then((a) {
      print('updated all documents inside Collection');
    });
  }

  Future likeCountOperationsById(
      String userId, String newsId, int count) async {
    _updateAllFromCollection(firestoreInstance.collection("news"), "newsId",
        "numLike", newsId, FieldValue.increment(count));

    if (count == 1) {
      _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
          "likedNews", userId, FieldValue.arrayUnion([newsId]));

      _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
          "dislikedNews", userId, FieldValue.arrayRemove([newsId]));
    }
  }

  Future dislikeCountOperationsById(
      String userId, String newsId, int count) async {
    _updateAllFromCollection(firestoreInstance.collection("news"), "newsId",
        "numDislike", newsId, FieldValue.increment(count));

    if (count == 1) {
      _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
          "dislikedNews", userId, FieldValue.arrayUnion([newsId]));

      _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
          "likedNews", userId, FieldValue.arrayRemove([newsId]));
    }
  }

  Future newArticleReading(
      List<String> categories, String userID, String newsId) async {
    _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
        "numOfArticles", userID, FieldValue.increment(1));

    print("1");
    categories.forEach((element) {
      _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
          "num" + element, userID, FieldValue.increment(1));
    });
    print("2");
    _updateAllFromCollection(firestoreInstance.collection("users"), "userId",
        "visitedNews", userID, FieldValue.arrayUnion([newsId]));

    print("3");
  }

  Future getBlogsById(String userId, List<Blog> blogsById) async {
    firestoreInstance
        .collection("blog")
        .where('userId', isEqualTo: userId)
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

  Future<List<String>> getLikedItemIds(String userID) async {
    List<String> likedNews = [];
    await firestoreInstance
        .collection("users")
        .where('userId', isEqualTo: userID)
        .get()
        .then((querySnapshot) {
      Users temp = Users.fromJson(querySnapshot.docs.first.data());
      likedNews = temp.likedNews!;
    }).catchError((error) => print('Error: ${error.toString()}'));
    return likedNews;
  }

  Future<News> getNewsById(String newsId) async {
    var x;
    await firestoreInstance
        .collection("news")
        .where('newsId', isEqualTo: newsId)
        .get()
        .then((querySnapshot) {
      x = News.fromJson(querySnapshot.docs.first.data());
    }).catchError((error) => print('Error: ${error.toString()}'));
    return x;
  }
}
