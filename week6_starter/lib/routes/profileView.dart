import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';



class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  AuthService auth = AuthService();
  DBService db = DBService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text("31");
              } else {
                return CircularProgressIndicator();
              }
            },
            future: Provider.of(context).auth.getCurrentUID(), //??????hata???????????
          ),
        ],
      ),
    );
  }
}

