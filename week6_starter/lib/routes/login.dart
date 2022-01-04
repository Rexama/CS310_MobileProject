import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/routes/welcome.dart';
import 'package:week6_starter/services/analytics.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:week6_starter/routes/feedView.dart';
import 'package:week6_starter/routes/navigationBar.dart';

class Login extends StatefulWidget {
  @override
  const Login({Key? key, required this.analytics, required this.observer})
      : super(key: key);
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

  AuthService auth = AuthService();
  //FirebaseAuth auth = FirebaseAuth.instance;

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  /*changePassword() async {
    try {
      Stream<User?> currUser = auth.user;

    }
  }*/

  Future<void> loginUser() async {
    var res = await auth.loginWithMailAndPass(mail, pass);

    print("res print:" + res.toString());
    if (res != null && res != "3" && res != "4") //successful
    {
      print("OK res print:" + res.toString());
    } else if (res == "3") {
      setMessage("Please check your e-mail and password");
    } else {
      setMessage("An error has occurred");
    }


  }

  Future<void> logoutUser() async {
    var res = auth.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*auth.authStateChanges().listen((User? user) {
      if(user == null){
        print('User is signed out');
      }
      else{
        print('User is signed out');
      }
    });*/
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      //FirebaseCrashlytics.instance.crash();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context)
                .push(
              MaterialPageRoute(builder: (context) => Welcome(analytics: widget.analytics, observer: widget.observer)),
            )
                .then((value) => {setState(() {})}),
          ),
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
                          setLogEvent(widget.analytics, 'signup',
                              _formKey.currentState!.validate());
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print('Mail: ' + mail + "\nPass: " + pass);
                            loginUser();
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
                            style: TextStyle(
                                color: AppColors.openBlue,
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
                          auth.signInWithGoogle();
                        },
                        icon: Image.asset(
                          // didnt work?
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
                  SizedBox(height: 8),
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
    } else {
      //show feed view
      return Home(analytics: widget.analytics, observer: widget.observer);

      /*return Scaffold(//dummy feedview
        appBar: AppBar(
          title: Text("User is logged in"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            OutlinedButton(
              onPressed: () {
                logoutUser();
              },
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                '   Logout   ', //Attempt: ${count!=null ? count:0}',
                style: blogText,
              ),
            ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.midBlue,
              ),
           ),
          ],
        ),
      );*/
      //return FeedView();
    }
  }
}
