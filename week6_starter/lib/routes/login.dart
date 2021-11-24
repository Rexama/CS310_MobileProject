import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:week6_starter/utils/api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String pass = "";
  late int count;

  void getUser() async {
    final url = Uri.parse(API.allUsers);

    final response = await http.get(
      Uri.https(url.authority, url.path),
      headers: <String, String> {
        "Accept": "application/json",
        "Content-Type": "charset=UTF-8",
      }
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      //SUCCESS
      //showAlertDialog('Response', response.body);
      var responseList = jsonDecode(response.body) as List;
      showAlertDialog('User at index 1', '${responseList[1]}');
    }
    else {
      showAlertDialog('HTTP Error: ${response.statusCode}', response.body);
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    bool isiOS = Platform.isIOS;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isiOS) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(message),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),)
              ],
            );
          } else {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(message),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),)
              ],
            );
          }

        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: Dimen.regularPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: AppColors.secondary,
                          filled: true,
                          hintText: 'E-mail',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,

                        validator: (value) {
                          if(value == null) {
                            return 'E-mail field cannot be empty';
                          } else {
                            String trimmedValue = value.trim();
                            if(trimmedValue.isEmpty) {
                              return 'E-mail field cannot be empty';
                            }
                            if(!EmailValidator.validate(trimmedValue)) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },

                        onSaved: (value) {
                          if(value != null) {
                            mail = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: AppColors.secondary,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,

                        validator: (value) {
                          if(value == null) {
                            return 'Password field cannot be empty';
                          } else {
                            String trimmedValue = value.trim();
                            if(trimmedValue.isEmpty) {
                              return 'Password field cannot be empty';
                            }
                            if(trimmedValue.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                          }
                          return null;
                        },

                        onSaved: (value) {
                          if(value != null) {
                            pass = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            print('Mail: '+mail+"\nPass: "+pass);
                            _formKey.currentState!.save();
                            print('Mail: '+mail+"\nPass: "+pass);
                            getUser();
                          }
                          else {
                            setState(() {
                              count+=1;
                              showAlertDialog('Error', 'You have tried your luck $count times');
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Login Attempt: ${count!=null ? count:0}',
                            style: kButtonDarkTextStyle,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
