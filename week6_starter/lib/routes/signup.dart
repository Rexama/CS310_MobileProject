import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:week6_starter/services/analytics.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  @override
  const SignUp({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _message = "";
  String mail = "";
  String pass = "";
  String tempPass = ""; //password confirm icin gerekli kurcalama
  String username = "";
  late int count;

  AuthService auth = AuthService();
  DBService db = DBService();
  //FirebaseAuth auth = FirebaseAuth.instance;

  void setmessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  Future<void> signupUser() async {
    var res = auth.signupWithMailAndPass(mail, pass);
    db.addUserAutoID(username, mail, 'token');
    if(res != null && res != "1" && res != "2")
    {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign Up Successful"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            );
          });
    }
    else if(res == "1") {
      setmessage("This email is already in use");
    }
    else if(res == "2"){
      setmessage("Weak password");
    }
    else{
      setmessage("An error has occurred");
    }

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
          'SIGN UP',
          style: blogText,
        ),
        backgroundColor: AppColors.darkBlue,
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
                SizedBox(
                  height: 30,
                ),
                /*Container(
                  height: 200,
                  child: CircleAvatar(
                    backgroundColor: AppColors.midBlue,
                    radius: 80,
                    backgroundImage: AssetImage('assets/login.jpg'),
                  ),
                ),*/ //from login
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: AppColors.darkestBlue,
                          filled: true,
                          hintText: 'E-mail',
                          hintStyle: TextStyle(
                            color: AppColors.openBlue,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.midBlue),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null) {
                            return 'E-mail field cannot be empty';
                          } else {
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return 'E-mail field cannot be empty';
                            }
                            if (!EmailValidator.validate(trimmedValue)) {
                              return 'Please enter a valid email';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            mail = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          fillColor: AppColors.darkestBlue,
                          filled: true,
                          hintText: 'User Name',
                          hintStyle: TextStyle(
                            color: AppColors.openBlue,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.midBlue),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) {
                            return 'User Name cannot be empty.';
                          } else {
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return 'User Name field cannot be empty';
                            }
                            /*if (!EmailValidator.validate(trimmedValue)) { //from login
                              return 'Please enter a valid email';
                            }*/
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            username = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: (TextStyle(color: AppColors.whiteBlue)),
                        decoration: InputDecoration(
                          fillColor: AppColors.darkestBlue,
                          filled: true,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppColors.openBlue),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.openBlue),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          bool flag = true;
                          if (value == null) {
                            flag = false;
                            return 'Password field cannot be empty';
                          } else {
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              flag = false;
                              return 'Password field cannot be empty';
                            }
                            if (trimmedValue.length < 8) {
                              flag = false;
                              return 'Password must be at least 8 characters long';
                            }
                            if (flag) {
                              tempPass =
                                  value; //this is for to check confirm pass field
                            }
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            pass = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: (TextStyle(color: AppColors.whiteBlue)),
                        decoration: InputDecoration(
                          fillColor: AppColors.darkestBlue,
                          filled: true,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: AppColors.openBlue),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.openBlue),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value != tempPass) {
                            return 'Passwords must match.';
                          } /* else { //from login
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return 'Password field cannot be empty';
                            }
                            if (trimmedValue.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                          }*/
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            pass = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        setLogEvent(this.widget.analytics, 'signup', _formKey.currentState!.validate());
                        if (_formKey.currentState!.validate()) {
                          print('Mail: ' +
                              mail +
                              "\nUsername: " +
                              username +
                              "\nPass: " +
                              pass);
                          _formKey.currentState!.save();
                          print('Mail: ' +
                              mail +
                              "\nUsername: " +
                              username +
                              "\nPass: " +
                              pass);
                          signupUser();
                          setState(() {
                            count += 1;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '   Sign Up   ', //Attempt: ${count!=null ? count:0}',
                          style: blogText,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.midBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                /* Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        var a = signInWithGoogle();
                        print("zaxd\n" + a.toString());
                      },
                      icon: Image.asset( // didnt work?
                        'assets/Google__G__Logo.svg.png',
                        height: 18,
                        width: 18,
                      ),
                      //icon: Icon(Icons.security),
                      label: Text('Sign up with Google'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ],
                ),*/
                Text(
                  _message,
                  style: TextStyle(color: AppColors.whiteBlue),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.darkestBlue,
    );
  }
}
