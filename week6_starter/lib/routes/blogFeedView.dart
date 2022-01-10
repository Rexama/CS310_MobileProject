import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/models/Users.dart';
import 'package:week6_starter/routes/postBlogView.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:week6_starter/routes/blogView.dart';
import 'package:intl/intl.dart';

class BlogFeedView extends StatefulWidget {
  @override
  const BlogFeedView({Key? key, required this.analytics, required this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _BlogFeedView createState() => _BlogFeedView();
}

class _BlogFeedView extends State<BlogFeedView> {
  AuthService auth = AuthService();
  DBService db = DBService();
  List<Blog> allBlogs = [];
  late Future _future = db.getBlogs(allBlogs);
  bool isAnon = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user!.isAnonymous)
    {
      isAnon = true;
    }
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          _future.then((data) {
            setState(() {
              this.allBlogs = allBlogs;
            });
          });
          if (allBlogs.isEmpty) {
            sleep(Duration(seconds: 1));
            //setState(() {});
          }
          return Scaffold(
            backgroundColor: Colors.white24,
            appBar: AppBar(
              backgroundColor: AppColors.darkBlue,
              leading: IconButton(
                onPressed: () {
                  auth.signOut();
                },
                icon: Icon(Icons.logout),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            body: Padding(
              padding: Dimen.regularPadding,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: allBlogs.isEmpty
                      ? Container()
                      : ListView.builder(
                          itemCount: allBlogs.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (allBlogs[index].isActive) {
                              return InkWell(
                                  onTap: () async {
                                    if(!isAnon)
                                      {
                                        Users author = await db.getUser(allBlogs[index].userId) as Users;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlogView(
                                                    analytics: widget.analytics,
                                                    observer: widget.observer,
                                                    content: allBlogs[index],
                                                    user: author),
                                          ),
                                        );
                                      } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("You must be signed in to see details of a blog"),
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
                                  },
                                  child: Container(
                                    height: 170,
                                    child: Card(
                                      child: Container(
                                        height: 170,
                                        color: Colors.white10,
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: allBlogs[index].image!.isEmpty
                                                      ? Icon(
                                                    Icons.image_not_supported,
                                                    size: 75,
                                                  )
                                                      : Image.network(
                                                    allBlogs[index].image as String,
                                                    width: 75,
                                                    height: 75,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    ListTile(
                                                      dense: true,
                                                      //contentPadding: EdgeInsets.only(left: 20.0, right: 5.0),
                                                      contentPadding:
                                                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                                      title: Text(
                                                        allBlogs[index].title.length > 20
                                                            ? allBlogs[index].title.substring(0, 18) + '..'
                                                            : allBlogs[index].title,
                                                        style: newsTextBoldDark,
                                                      ),
                                                      subtitle: Text(
                                                        allBlogs[index].content.length > 125
                                                            ? allBlogs[index].content.substring(0, 80) + '...'
                                                            : allBlogs[index].content,
                                                        style: GoogleFonts.robotoSlab(
                                                          color: AppColors.darkestBlue,
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          DateFormat().format(allBlogs[index].uploadDate).toString(),
                                                          style: GoogleFonts.robotoSlab(
                                                            color: AppColors.darkBlue,
                                                            fontSize: 12.0,
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
                                      elevation: 10,
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    ),
                                  ));
                            } else {
                              return Container();
                            }
                          },
                        ),
                )
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.create,
                color: AppColors.whiteBlue,
              ),
              onPressed: () async {
                if (!user.isAnonymous) {
                  Users blogOwner = await db.getUserByUid(user.uid) as Users;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostBlogFeedView(
                                analytics: widget.analytics,
                                observer: widget.observer,
                                userId: blogOwner.userId,
                              )));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("You are not logged in!"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          );
        });
  }
}
