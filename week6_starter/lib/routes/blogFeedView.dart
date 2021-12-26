import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/models/Blog.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:week6_starter/routes/blogView.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class BlogFeedView extends StatefulWidget {
  @override
  const BlogFeedView(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _BlogFeedView createState() => _BlogFeedView();
}

class _BlogFeedView extends State<BlogFeedView> {
  AuthService auth = AuthService();
  DBService db = DBService();
  List<Blog> allBlogs = [];
  late Timer _timer;

  int currentIndex = 0;

  @override
  void initState() {
    db.getBlogs(allBlogs).then((data) {
      setState(() {
        this.allBlogs = allBlogs;
      });
    });
    _timer = Timer.periodic(Duration(seconds: 0), (Timer t) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlogView(content: allBlogs[index]),
                                ),
                              );
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
                                            child: allBlogs[index].image == null
                                                ? Icon(
                                                    Icons.image_not_supported,
                                                    size: 75,
                                                  )
                                                : Image.network(
                                                    allBlogs[index].image
                                                        as String,
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
                                                dense:true,
                                                //contentPadding: EdgeInsets.only(left: 20.0, right: 5.0),
                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal:5.0),
                                                title: Text(
                                                  allBlogs[index].title.length >
                                                          20
                                                      ? allBlogs[index]
                                                              .title
                                                              .substring(
                                                                  0, 18) +
                                                          '..'
                                                      : allBlogs[index].title,
                                                  style: newsTextBoldDark,
                                                ),
                                                subtitle: Text(
                                                  allBlogs[index]
                                                              .content
                                                              .length >
                                                          125
                                                      ? allBlogs[index]
                                                              .content
                                                              .substring(
                                                                  0, 80) +
                                                          '...'
                                                      : allBlogs[index].content,
                                                  style: GoogleFonts.robotoSlab(
                                                    color:
                                                        AppColors.darkestBlue,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat()
                                                        .format(allBlogs[index]
                                                            .uploadDate)
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.robotoSlab(
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
                      },
                    ),
            )
          ]),
        ));
  }
}
