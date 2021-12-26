import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/routes/blogFeedView.dart';
import 'package:week6_starter/routes/exploreView.dart';
import 'package:week6_starter/routes/profileView.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/routes/feedView.dart';

class Home extends StatefulWidget {
  @override
  const Home({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthService auth = AuthService();
  DBService db = DBService();

  late int _currentIndex;
  late List<Widget> _children;

  /*final screens =[
    Center(child: Text("feed")),
    Center(child: Text("blog")),
    Center(child: Text("explore")),
    Center(child: Text("profile")),
  ];*/

  @override
  void initState() {
    _currentIndex = 0;
    _children = [
      FeedView(analytics: widget.analytics, observer: widget.observer),
      BlogFeedView(analytics: widget.analytics, observer: widget.observer),
      exploreView(analytics: widget.analytics, observer: widget.observer),
      ProfileView(analytics: widget.analytics, observer: widget.observer),
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.openBlue,
        showUnselectedLabels: false,
        iconSize: 35,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.darkestBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_color_rounded),
            label: 'Blog',
            backgroundColor: AppColors.darkestBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Explore',
            backgroundColor: AppColors.darkestBlue,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: AppColors.darkestBlue,
          ),
        ],
      ),

    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}
