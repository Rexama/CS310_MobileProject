import 'package:flutter/material.dart';
import 'package:week6_starter/services/auth.dart';

class FeedView extends StatelessWidget {

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            auth.signOut();
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: Text(
          'FEED VIEW',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}