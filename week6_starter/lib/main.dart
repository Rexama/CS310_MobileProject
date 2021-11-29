import 'package:flutter/material.dart';
import 'package:week6_starter/routes/welcome.dart';
import 'package:week6_starter/routes/login.dart';
import 'package:week6_starter/routes/signup.dart';
import 'package:week6_starter/routes/walkthrough.dart';


void main() => runApp(MaterialApp(

  routes: {
    '/': (context) => Walkthrough(),
    '/welcome': (context) => Welcome(),
    '/login': (context) => Login(),
    '/signup': (context) => SignUp(),
  },
));
