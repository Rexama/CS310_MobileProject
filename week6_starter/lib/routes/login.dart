import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  const Login({Key? key, required this.analytics, required this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _message = "";
  String mail = "";
  String pass = "";
  late int count;
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void setMessage(String msg){
    setState(() {
      _message = msg;
    });
  }


  Future <void> loginUser() async{
    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(
          email: mail,
          password: pass
      );
      print(userCredential.toString());

    } on FirebaseAuthException catch(e){
      print(e.toString());

      if (e.code == 'user-not-found')
      {
        setMessage('User not found');
      }
      else if (e.code == 'wrong-password')
      {
        setMessage('Please check your password');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    auth.authStateChanges().listen((User? user) {
      if(user == null){
        print('User is signed out');
      }
      else{
        print('User is signed out');
      }

    });
    count = 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOGIN',
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
                Container(
                  height: 200,
                  child: CircleAvatar(
                    backgroundColor: AppColors.midBlue,
                    radius: 80,
                    backgroundImage: AssetImage('assets/login.jpg'),
                  ),
                ),
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
                          if (value == null) {
                            return 'Password field cannot be empty';
                          } else {
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return 'Password field cannot be empty';
                            }
                            if (trimmedValue.length < 8) {
                              return 'Password must be at least 8 characters long';
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
                  height: 32,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('Mail: ' + mail + "\nPass: " + pass);
                          _formKey.currentState!.save();
                          print('Mail: ' + mail + "\nPass: " + pass);
                          setState(() {
                          count += 1;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '   Login   ', //Attempt: ${count!=null ? count:0}',
                          style: blogText,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.midBlue,
                        ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '   Forgot Password?   ',
                          //Attempt: ${count!=null ? count:0}',
                          style: TextStyle(color: AppColors.openBlue,
                              fontSize: 15,
                              fontStyle: FontStyle.normal),

                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        var a = signInWithGoogle();
                        print("***GOOGLE SIGNIN CREDENTIALS:***\n" + a.toString());
                      },
                      icon: Image.asset( // didnt work?
                        'assets/Google__G__Logo.svg.png',
                        height: 18,
                        width: 18,
                      ),
                      //icon: Icon(Icons.security),
                      label: Text('Login with Google'),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ],
                ),
                Text(
                  _message,
                  style: TextStyle(
                      color: AppColors.whiteBlue
                  ),
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

