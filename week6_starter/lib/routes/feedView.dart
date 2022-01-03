import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
//import 'package:week6_starter/routes/navigation.dart';
import 'package:week6_starter/models/News.dart';
import 'package:week6_starter/routes/newsView.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';

class FeedView extends StatefulWidget {
  @override
  const FeedView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _FeedView createState() => _FeedView();
}

class _FeedView extends State<FeedView> {
  AuthService auth = AuthService();
  DBService db = DBService();
  List<News> allNews = [];
  bool isAnon = false;
  late Future _future = db.getNews(allNews);

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
            this.allNews = allNews;
          });
        });
        if (allNews.isEmpty) {
          sleep(Duration(seconds:1));
          //setState(() {});
        }
        return Scaffold(
          backgroundColor: Colors.white,
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: ListView.builder(
                  itemCount: allNews.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsView(
                                    analytics: widget.analytics,
                                    observer: widget.observer,
                                    content: allNews[index]),
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
                                      child: allNews[index].image == null
                                          ? Icon(
                                        Icons.image_not_supported,
                                        size: 75,
                                      )
                                          : Image.network(
                                        allNews[index].image as String,
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
                                          dense: true,
                                          //contentPadding: EdgeInsets.only(left: 20.0, right: 5.0),
                                          contentPadding:
                                          EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 3.0),
                                          title: Text(
                                            allNews[index].title.length > 20
                                                ? allNews[index]
                                                .title
                                                .substring(0, 18) +
                                                '..'
                                                : allNews[index].title,
                                            style: newsTextBoldDark,
                                          ),
                                          subtitle: Text(
                                            allNews[index].subtitle.length >
                                                125
                                                ? allNews[index]
                                                .subtitle
                                                .substring(0, 122) +
                                                '...'
                                                : allNews[index].subtitle,
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
                                              allNews[index]
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
                                              allNews[index]
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
                          elevation: 8,
                          margin: EdgeInsets.all(10),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        );
      }
    );
  }
}
