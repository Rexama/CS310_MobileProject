import 'package:flutter/material.dart';
import 'package:week6_starter/routes/welcome.dart';
import 'package:week6_starter/routes/login.dart';
import 'package:week6_starter/routes/signup.dart';
import 'package:week6_starter/routes/walkthrough.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';

void main() {
  //Shared prefs
  //https://pub.dev/packages/shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyFirebaseApp());
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //in case connection fails
          return MaterialApp(
              home: Scaffold(body: Center(child: Text("no connection"))));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //if we are connected
          log("conected");
          return MyApp();
        }
        return MaterialApp(
            //while connecting...
            home: Scaffold(body: Center(child: Text("connecting..."))));
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => Walkthrough(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
      },
    );
  }
}
