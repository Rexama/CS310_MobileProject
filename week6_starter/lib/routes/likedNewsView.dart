import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
//import 'package:week6_starter/routes/navigation.dart';
import 'package:week6_starter/models/News.dart';
import 'package:week6_starter/routes/newsView.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';

class LikedNews extends StatefulWidget {
  final String userId;
  const LikedNews(
      {Key? key,
        required this.analytics,
        required this.observer,
        required this.userId})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _LikedNews createState() => _LikedNews();
}


class _LikedNews extends State<LikedNews> {
  AuthService auth = AuthService();
  DBService db = DBService();
  List<String> likedNewsIds = [];
  List<News> likedNewsToUse = [];
  News? tempNew;

  int currentIndex = 0;

  @override
  void initState() {
    print(widget.userId);
    getItems();
    print("likedNewsIds");
    print(likedNewsIds);

    super.initState();
    }


  getItems() async {
    await db.getLikedItemIds(widget.userId).then((data) {
      setState(() {
        print(data);
        this.likedNewsIds = data;
        print("likedNewsIdsF");
        print(likedNewsIds);
      });
    });
    print("pushitems");
    print(likedNewsIds);
    for(var elem in likedNewsIds){
      await db.getNewsById(elem).then((data) {
        setState(() {
          this.tempNew = data;
        });
        likedNewsToUse.add(tempNew!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
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
            child: likedNewsToUse.isEmpty
                ? Container()
                : ListView.builder(
              itemCount: likedNewsToUse.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsView(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            content: likedNewsToUse[index]),
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
                                  child: likedNewsToUse[index].image == null
                                      ? Icon(
                                    Icons.image_not_supported,
                                    size: 75,
                                  )
                                      : Image.network(
                                    likedNewsToUse[index].image as String,
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
                                        likedNewsToUse[index].title.length > 20
                                            ? likedNewsToUse[index]
                                            .title
                                            .substring(0, 18) +
                                            '..'
                                            : likedNewsToUse[index].title,
                                        style: newsTextBoldDark,
                                      ),
                                      subtitle: Text(
                                        likedNewsToUse[index].subtitle.length >
                                            125
                                            ? likedNewsToUse[index]
                                            .subtitle
                                            .substring(0, 122) +
                                            '...'
                                            : likedNewsToUse[index].subtitle,
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
                                          likedNewsToUse[index]
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
                                          likedNewsToUse[index]
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
}



