import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week6_starter/services/analytics.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/utils/color.dart';

class Walkthrough extends StatefulWidget {

  const Walkthrough({Key? key, required this.analytics, required this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {

  int currentPage = 0;
  int lastPage = 2;

  _firstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
  }

  void nextPage() {
    if (currentPage < lastPage) {
      setState(() {
        currentPage++;
      });
    }
    else {
      _firstLaunch();
      setLogEvent(this.widget.analytics, 'walkthrough_end', true);
      Navigator.pop(context);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  List<String> titles = [
    'SIGNUP',
    'SELECT TOPICS',
    'LET\'S GET STARTED!',
  ];

  List<String> headers = [
    'Signup for free',
    'Select topics of interest',
    'Start getting updated',
  ];

  List<String> descriptions = [
    'This app is free source to get updated!',
    'Click the selection box of the topics!',
    'Scroll the news about the topics you select!',
  ];

  List<String> images = [
    'assets/sign-up-image.jpg',
    'assets/topic-image.jfif',
    'assets/news_image.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkestBlue,
      appBar: AppBar(
        title: Text(
          titles[currentPage],
          style: blogTextBold,
        ),
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Padding(
                padding: Dimen.regularPadding,
                child: Text(
                  headers[currentPage],
                  style: blogText,
                ),
              ),
            ),
            Container(
              height: 200,
              child: CircleAvatar(
                backgroundColor: AppColors.midBlue,
                radius: 140,
                backgroundImage: AssetImage(images[currentPage]),
              ),
            ),

            Center(
              child: Text(
                descriptions[currentPage],
                style: blogText,
              ),
            ),

            Padding(
              padding: Dimen.regularPadding,
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    OutlinedButton(
                        onPressed: previousPage,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.whiteBlue),
                        ),
                        child: Text(
                          'Previous',
                          style: blogText,
                        )
                    ),
                    Spacer(),
                    Text(
                      '${currentPage+1}/${lastPage+1}',
                      style: blogText,
                    ),
                    Spacer(),
                    OutlinedButton(
                        onPressed: nextPage,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.whiteBlue),
                        ),
                        child: Text(
                          'Next',
                          style: blogText,
                        )
                    ),

                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
