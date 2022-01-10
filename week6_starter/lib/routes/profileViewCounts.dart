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
    return Container();
  }
}