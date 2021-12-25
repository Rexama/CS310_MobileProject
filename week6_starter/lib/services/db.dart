import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/News.dart';

class DBService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final firestoreInstance = FirebaseFirestore.instance;

  Future addUserAutoID(String username, String mail, String token) async {
    List<String> strList = [];
    userCollection
        .doc(token)
        .set({
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

  //Future getNew(int id, List<News> allNews) async {
  //  firestoreInstance.collection("news").doc("").get().then((querySnapshot) {
  //    querySnapshot.docs.forEach((result) {
  //      News tempNew = News.fromJson(result.data());
  //      allNews.add(tempNew);
  //    });
  //  });
  //  return allNews;
  //}

  Future getBlogs(List<Blog> allBlogs) async {
    firestoreInstance.collection("blog").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Blog tempBlog = Blog.fromJson(result.data());
        allBlogs.add(tempBlog);
      });
    });
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
}
