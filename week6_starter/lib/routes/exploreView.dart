import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:week6_starter/routes/exploreResultsView.dart';

class exploreView extends StatefulWidget {
  @override
  const exploreView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _exploreView createState() => _exploreView();
}

class _exploreView extends State<exploreView> {
  @override
  AuthService auth = AuthService();
  DBService db = DBService();

  Widget build(BuildContext context) {
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
          //padding: const EdgeInsets.all(8.0),
          padding: Dimen.regularPadding,
          child: Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                InkWell(
                  onTap: () {
                    print("PUSHED");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreResults(category: 'Science', observer: widget.observer, analytics: widget.analytics,),
                        ));
                  },
                  child: Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/science_image2.jpg'),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Science',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteBlue)),
                          ))),
                ),
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreResults(category: 'Finance', observer: widget.observer, analytics: widget.analytics,),
                        ));
                  },
                  child: Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/finans_image.jpg'),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Finance',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteBlue)),
                          ))),
                ),
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreResults(category: 'Sports', observer: widget.observer, analytics: widget.analytics,),
                        ));
                  },
                  child: Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/sports_image2.jfif'),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Sports',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteBlue)),
                          ))),
                ),
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreResults(category: 'History', observer: widget.observer, analytics: widget.analytics,),
                        ));
                  },
                  child: Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/history_image.jpg'),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('History',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteBlue)),
                          ))),
                ),
                SizedBox(
                  height: 25.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExploreResults(category: 'Magazine', observer: widget.observer, analytics: widget.analytics,),
                        ));
                  },
                  child: Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/magazine_image2.jpg'),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Magazine',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteBlue)),
                          ))),
                ),
              ],
            ),
          )
          /*child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Expanded(

            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/scince_iamge.jpg'),
                          height: 250,
                          width: 250,
                          child: Center(
                            child:
                                Text('Science', style: TextStyle(fontSize: 32)),
                          ))),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/finance_image.jpeg'),
                          height: 250,
                          width: 250,
                          child: Center(
                            child:
                                Text('Finance', style: TextStyle(fontSize: 32)),
                          ))),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/sports_image.jpg'),
                          height: 250,
                          width: 250,
                          child: Center(
                            child:
                                Text('Sports', style: TextStyle(fontSize: 32)),
                          ))),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/history_image.jfif'),
                          height: 250,
                          width: 250,
                          child: Center(
                            child:
                                Text('History', style: TextStyle(fontSize: 32)),
                          ))),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      height: 100,
                      width: 250,
                      child: Ink.image(
                          image: AssetImage('assets/magazine_image.jpg'),
                          height: 250,
                          width: 250,
                          child: Center(
                            child: Text('Magazine',
                                style: TextStyle(fontSize: 32)),
                          ))),
                ]),
          ),
        ),*/
          ),
    );
  }
}
