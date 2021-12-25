import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/News.dart';


class DBService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  Future addUserAutoID(String username, String mail, String token) async {
    userCollection.add({
      'username': username,
      'userToken': token,
      'email': mail
    })
        .then((value) => print('User added'))
        .catchError((error) => print('Error: ${error.toString()}'));
  }

  Future addUser(String name, String surname, String mail, String token) async {
    userCollection.doc(token).set({
      'name': name,
      'surname': surname,
      'userToken': token,
      'email': mail
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

  Future getBlogs(List<Blog> allBlogs) async {
    firestoreInstance.collection("blog").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Blog tempBlog = Blog.fromJson(result.data());
        allBlogs.add(tempBlog);
      });
    });
  }
}