import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/News.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Users.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:comment_box/comment/test.dart';
import 'package:comment_box/main.dart';

class NewsView extends StatefulWidget {
  @override
  const NewsView(
      {Key? key,
      required this.analytics,
      required this.observer,
      required this.content})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final News content;

  _NewsView createState() => _NewsView();
}

class _NewsView extends State<NewsView> {
  List<Comment> comments = [];
  DBService db = DBService();
  late Timer _timer;

  @override
  void initState() {
    db.getComments(comments, widget.content.newsId, false).then((data) {
      setState(() {
        this.comments = comments;
      });
    });
    print(comments);
    print("aaa");
    //_timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
    //super.initState();
    print(comments);
  }

  /*@override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("kaanıskm");
    print(comments[0].content);
    print(comments.length);
    print("kaanıskm");
    String comment = "";
    return FutureBuilder(
        future: db.userCollection.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users userClass =
                Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            print(userClass.userName);
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.content.title),
              ),
              body: ListView(padding: const EdgeInsets.all(8.0), children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //let's add the height

                        image: DecorationImage(
                            image:
                                NetworkImage(widget.content.image.toString()),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        widget.content.subtitle,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      widget.content.content,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: comments.isEmpty
                          ? Container()
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    comments[index].username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(comments[index].content),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your comment here ...',
                        hintStyle: TextStyle(
                          color: AppColors.openBlue,
                        ),
                      ),
                      maxLines: 1,
                      onChanged: (value) {
                        comment = value;
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.midBlue,
                        ),
                        child: Text("Comment"),
                        onPressed: () {
                          db.addComment(
                              comment, userClass.userName, "d327", false);
                        }),
                  ],
                ),
              ]),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

/*class NewView extends StatefulWidget {
  const NewView({Key? key, required this.News}) : super(key: key);
  @override
  const NewView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _NewView createState() => _NewView();
}

class _NewView extends State<NewView> {
  AuthService auth = AuthService();
  DBService db = DBService();
  List<News> content = [];
  late Timer _timer;

  int currentIndex = 0;

  @override
  void initState() {
    db.getNews(content).then((data) {
      setState(() {
        this.content = content;
      });
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content[0].title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                //let's add the height

                image: DecorationImage(
                    image: NetworkImage(content[0].image.toString()),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                content.source.name,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              content[].content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}*/
