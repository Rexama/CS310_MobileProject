import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Comment.dart';
import 'package:week6_starter/models/Users.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/styles.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key? key, required this.analytics, required this.observer, required this.content, required this.user})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final Blog content;
  final Users user;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  final DBService db = DBService();
  final AuthService auth = AuthService();

  List<Comment> comments = [];
  String comment = "";

  @override
  void initState() {
    db.getComments(comments, widget.content.blogId, true).then((data) {
      setState(() {
        this.comments = comments;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currUser = Provider.of<User?>(context);

    return FutureBuilder(
        future: db.userCollection.doc(currUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users currentUser = Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.darkBlue,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity,
                          decoration: widget.content.image!.isEmpty
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.midBlue,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                )
                              : BoxDecoration(
                                  //let's add the height
                                  image: DecorationImage(
                                      image: NetworkImage(widget.content.image.toString()), fit: BoxFit.cover),
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
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.content.title,
                            style: GoogleFonts.nunito(
                              color: AppColors.darkestBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.content.content,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.user.isPriv
                                ? ClipOval(
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                  )
                                : (widget.user.image!.isEmpty
                                    ? ClipOval(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                        ),
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          widget.user.image as String,
                                          width: 40,
                                          height: 40,
                                        ),
                                      )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.user.isPriv ? "Private Account" : widget.user.userName,
                              style: newsTextBoldDark,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(
                                future: db.getUser(comments[index].userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    Users user = snapshot.data! as Users;
                                    if (user.isActive) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                user.image!.isEmpty
                                                    ? ClipOval(
                                                        child: Icon(
                                                          Icons.image_not_supported,
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
                              if (!currUser.isAnonymous) {
                                print("bn burdayimmm " + comment);
                                await db.addComment(comment, widget.content.blogId, currentUser.userId, true);
                                await db.getComments(comments, widget.content.blogId, true).then((data) {
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
                                        title: Text("You must be signed in to leave a comment"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              auth.signOut();
                                              Navigator.pushNamed(context, '/login');
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
                      ],
                    ),
                  ],
                ),
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
