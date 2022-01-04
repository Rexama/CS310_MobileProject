import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
//import 'package:week6_starter/routes/navigation.dart';

class BlogView extends StatefulWidget {
  @override
  const BlogView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _BlogView createState() => _BlogView();
}

class _BlogView extends State<BlogView> {

  AuthService auth = AuthService();
  DBService db = DBService();

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    db.addUserAutoID('username', 'mail', 'token');
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
      body: Center(
        child: Text(
          'BLOG VIEW',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.lightBlue,
          ),
        ),
      ),

      /*

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.openBlue,
        showUnselectedLabels: false,
        iconSize: 35,
        currentIndex: currentIndex,
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

       */
    );
  }
}