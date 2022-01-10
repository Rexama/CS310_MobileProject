import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class ProfileViewCounts extends StatefulWidget {
  @override
  const ProfileViewCounts({Key? key, required this.analytics, required this.observer, required this.numOfArticles
    , required this.numHist, required this.numFinance, required this.numMagazine,
    required this.numScience, required this.numSports}) : super(key: key);
  final int numOfArticles;
  final int numHist;
  final int numFinance;
  final int numMagazine;
  final int numScience;
  final int numSports;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _ProfileViewCounts createState() => _ProfileViewCounts();
}

class _ProfileViewCounts extends State<ProfileViewCounts> {
  AuthService auth = AuthService();
  DBService db = DBService();
  bool isAnon = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.article,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text(
                'Articles',
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                widget.numOfArticles.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(
            ),
            ListTile(
              leading: Icon(
                Icons.history_edu,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text('History',
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                widget.numHist.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.attach_money,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text(
                  'Finance',
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),),
              trailing: Text(
                widget.numFinance.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.campaign,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text(
                  'Magazine',
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                widget.numMagazine.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.science,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text(
                'Science',
                style: TextStyle(
                  fontSize: 19,
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                widget.numScience.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.sports_baseball,
                color: AppColors.darkestBlue,
                size: 35,
              ),
              title: Text(
                'Sports',
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: Text(
                widget.numSports.toString(),
                style: TextStyle(
                  color: AppColors.darkestBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}