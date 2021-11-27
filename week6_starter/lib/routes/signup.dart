import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/utils/color.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIGNUP',
          style: blogText,
        ),
        backgroundColor: AppColors.whiteBlue,
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }
}
