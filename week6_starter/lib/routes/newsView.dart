import 'dart:async';
import 'dart:io';
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
  AuthService auth = AuthService();

  //late Future _future = db.getComments(comments, widget.content.newsId, false);
  String comment = "";
  List<News> allNews = [];
  List<News> relatedNews = [];
  bool isAnon = false;
  //late Future _future = db.getRelNews(relatedNews);

  @override
  void initState() {
    db.getComments(comments, widget.content.newsId, false).then((data) {
      setState(() {
        this.comments = comments;
      });
    });

    db.getRelNews(relatedNews, widget.content.category, widget.content.newsId).then((data)
        {
          setState(() {
            this.relatedNews = relatedNews;
          });
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(comments.length);
    if (comments.length > 1) {
      print(comments[0].content);
    }
    final user = Provider.of<User?>(context);
    if (user!.isAnonymous) {
      isAnon = true;
    }
    return FutureBuilder(
        future: db.userCollection.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users userClass =
                Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            print(!userClass.visitedNews!.contains(widget.content.newsId));
            if (!userClass.visitedNews!.contains(widget.content.newsId)) {
              print(userClass.userId);
              db.newArticleReading(widget.content.category, userClass.userId,
                  widget.content.newsId);
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.darkBlue,
              ),
              body: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      widget.content.title,
                      style: GoogleFonts.robotoSlab(
                        color: AppColors.darkestBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
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
                          border: Border.all(
                            color: AppColors.midBlue,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.midBlue),
                          color: AppColors.whiteBlue,
                        ),
                        child: Text(
                          widget.content.subtitle,
                          style: GoogleFonts.robotoSlab(
                            color: AppColors.darkestBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.content.content,
                          style: GoogleFonts.robotoSlab(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (!isAnon) {
                                if (!userClass.likedNews!
                                    .contains(widget.content.newsId)) {
                                  if (userClass.dislikedNews!
                                      .contains(widget.content.newsId)) {
                                    //if disliked before
                                    await db.likeCountOperationsById(
                                        userClass.userId,
                                        widget.content.newsId,
                                        1);
                                    await db
                                        .dislikeCountOperationsById(
                                            userClass.userId,
                                            widget.content.newsId,
                                            -1)
                                        .then((data) {
                                      sleep(Duration(milliseconds: 250));
                                      setState(() {
                                        widget.content.numLike += 1;
                                        widget.content.numDislike -= 1;
                                      });
                                    });
                                  } else {
                                    //if not dislikedbefore
                                    await db
                                        .likeCountOperationsById(
                                            userClass.userId,
                                            widget.content.newsId,
                                            1)
                                        .then((data) {
                                      sleep(Duration(milliseconds: 250));
                                      setState(() {
                                        widget.content.numLike += 1;
                                      });
                                    });
                                  }
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "You must be signed in to leave a like"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              auth.signOut();
                                              Navigator.pushNamed(
                                                  context, '/login');
                                            },
                                            child: Text(
                                              'Get me to the login page',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Icon(
                              //0xff1b6609
                              Icons.thumb_up,
                              color: userClass.likedNews!
                                      .contains(widget.content.newsId)
                                  ? Color(0xff1b6609)
                                  : Color(0x8f1b6609),
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.content.numLike.toString(),
                            style: GoogleFonts.robotoSlab(
                              color: AppColors.darkBlue,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!isAnon) {
                                if (!userClass.dislikedNews!
                                    .contains(widget.content.newsId)) {
                                  if (userClass.likedNews!
                                      .contains(widget.content.newsId)) {
                                    //if liked before
                                    await db.dislikeCountOperationsById(
                                        userClass.userId,
                                        widget.content.newsId,
                                        1);
                                    await db
                                        .likeCountOperationsById(
                                            userClass.userId,
                                            widget.content.newsId,
                                            -1)
                                        .then((data) {
                                      sleep(Duration(milliseconds: 250));
                                      setState(() {
                                        widget.content.numDislike += 1;
                                        widget.content.numLike -= 1;
                                      });
                                    });
                                  } else {
                                    //if not liked before
                                    await db
                                        .dislikeCountOperationsById(
                                            userClass.userId,
                                            widget.content.newsId,
                                            1)
                                        .then((data) {
                                      sleep(Duration(milliseconds: 250));
                                      setState(() {
                                        widget.content.numDislike += 1;
                                      });
                                    });
                                  }
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "You must be signed in to leave a dislike"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              auth.signOut();
                                              Navigator.pushNamed(
                                                  context, '/login');
                                            },
                                            child: Text(
                                              'Get me to the login page',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Icon(
                              Icons.thumb_down,
                              color: userClass.dislikedNews!
                                      .contains(widget.content.newsId)
                                  ? Color(0xff7d060a)
                                  : Color(0x8f7d060a),
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.content.numDislike.toString(),
                            style: GoogleFonts.robotoSlab(
                              color: AppColors.darkBlue,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder(
                              future: db.getUser(comments[index].userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Users user = snapshot.data! as Users;
                                  if (user.isActive) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              user.image!.isEmpty
                                                  ? ClipOval(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : ClipOval(
                                                      child: Image.network(
                                                        user.image as String,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                    ),
                                              SizedBox(width: 5),
                                              Text(
                                                user.userName,
                                                style: GoogleFonts.nunito(
                                                  color: AppColors.darkestBlue,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              comments[index].content,
                                              style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                                return CircularProgressIndicator();
                              });
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
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
                          onPressed: () async {
                            if (!isAnon) {
                              await db.addComment(
                                  comment,
                                  widget.content.newsId,
                                  userClass.userId,
                                  false);
                              await db
                                  .getComments(
                                      comments, widget.content.newsId, false)
                                  .then((data) {
                                setState(() {
                                  this.comments = comments;
                                });
                              });
                              //update view
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "You must be signed in to leave a comment"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            auth.signOut();
                                            Navigator.pushNamed(
                                                context, '/login');
                                          },
                                          child: Text(
                                            'Get me to the login page',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Related News",
                          style: GoogleFonts.robotoSlab(
                            color: AppColors.darkestBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: relatedNews.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsView(
                                        analytics: widget.analytics,
                                        observer: widget.observer,
                                        content: relatedNews[index]),
                                  ),
                                );
                              },
                              child: Container(
                                height: 200,
                                child: Card(
                                  child: Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: relatedNews[index].image == null
                                                  ? Icon(
                                                Icons.image_not_supported,
                                                size: 75,
                                              )
                                                  : Image.network(
                                                relatedNews[index].image as String,
                                                width: 75,
                                                height: 75,
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    relatedNews[index].title.length > 20
                                                        ? relatedNews[index]
                                                        .title
                                                        .substring(0, 18) +
                                                        '..'
                                                        : relatedNews[index].title,
                                                    style: newsTextBoldDark,
                                                  ),
                                                  subtitle: Text(
                                                    relatedNews[index].subtitle.length >
                                                        125
                                                        ? relatedNews[index]
                                                        .subtitle
                                                        .substring(0, 90) +
                                                        '...'
                                                        : relatedNews[index].subtitle,
                                                    style: GoogleFonts.robotoSlab(
                                                      color: AppColors.darkestBlue,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.thumb_up,
                                                      color: Color(0xff1b6609),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      relatedNews[index]
                                                          .numLike
                                                          .toString(),
                                                      style: GoogleFonts.robotoSlab(
                                                        color: AppColors.darkBlue,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Icon(
                                                      Icons.thumb_down,
                                                      color: Color(0xff7d060a),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      relatedNews[index]
                                                          .numDislike
                                                          .toString(),
                                                      style: GoogleFonts.robotoSlab(
                                                        color: AppColors.darkBlue,
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  elevation: 3,
                                  margin: EdgeInsets.all(15),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
