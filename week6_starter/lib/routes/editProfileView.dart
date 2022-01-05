import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/models/Users.dart';
import 'package:week6_starter/widget/profileWidget.dart';
import 'package:week6_starter/widget/textFieldWidget.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/routes/editProfilePicture.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'changePass.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  AuthService auth = AuthService();
  DBService db = DBService();

  String _username = "";
  String _mail = "";
  String? _bio = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    print('user id: ${user!.uid}');

    return FutureBuilder(
        future: db.userCollection.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users userClass =
                Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            _username = userClass.userName;
            _mail = userClass.email;
            _bio = userClass.userBio;
            return Scaffold(
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 50),
                  ProfileWidget(
                    imagePath: userClass.image,
                    isEdit: true,
                    onClicked: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditPicture()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        "Username",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      TextFormField(
                        initialValue: userClass.userName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          _username = value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      TextFormField(
                        initialValue: userClass.email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          _mail = value;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        "Bio",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      TextFormField(
                        initialValue: userClass.userBio,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        onChanged: (value) {
                          _bio = value;
                          print(_bio);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.midBlue,
                      ),
                      child: Text("Save"),
                      onPressed: () {
                        db.updateProfile(
                            _username, _bio!, _mail, userClass.userToken);
                        Navigator.pop(context);
                      }),
                  TextButton(
                    onPressed: () async {
                      print("changepass clicked");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePass(analytics: widget.analytics, observer: widget.observer),
                          ));
                      //ChangePass(analytics: widget.analytics, observer: widget.observer);
                    },
                    child: Center(
                      child: Text(
                        'Change Password',
                        style:
                            TextStyle(color: AppColors.darkBlue, fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
