import 'package:flutter/material.dart';
import 'package:week6_starter/routes/welcome.dart';
import 'package:week6_starter/routes/login.dart';
import 'package:week6_starter/routes/signup.dart';


void main() => runApp(MaterialApp(
  //home: Welcome(),
  //initialRoute: '/login',
  routes: {
    '/': (context) => Welcome(),
    '/login': (context) => Login(),
    '/signup': (context) => SignUp(),
  },
));
