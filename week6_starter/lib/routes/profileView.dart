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
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/routes/editProfileView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AuthService auth = AuthService();
  DBService db = DBService();

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
            return Scaffold(
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 30),
                  ProfileWidget(
                      imagePath: userClass.image,
                      onClicked: () {
                        if (user.isAnonymous) {
                          return;
                        } else {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                    builder: (context) => EditProfileView()),
                              )
                              .then((value) => {setState(() {})});
                        }
                      }),
                  SizedBox(height: 20),
                  buildName(userClass),
                  SizedBox(height: 30),
                  Expanded(
                      child: Divider(
                    indent: 3,
                    endIndent: 3,
                    thickness: 2,
                    color: AppColors.darkBlue,
                  )),
                  buildBio(userClass),
                  Expanded(
                      child: Divider(
                    indent: 3,
                    endIndent: 3,
                    thickness: 2,
                    color: AppColors.darkBlue,
                  )),
                  const SizedBox(height: 30),

                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.midBlue,
                              ),
                              child: OutlinedButton(
                                onPressed: () async {},
                                child: Center(
                                  child: Text(
                                    "Favourites",
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.midBlue,
                              ),
                              child: OutlinedButton(
                                onPressed: () async {},
                                child: Center(
                                  child: Text(
                                    "My Posts",
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.midBlue,
                              ),
                              child: OutlinedButton(
                                onPressed: () async {},
                                child: Center(
                                  child: Text(
                                    "Read Counts",
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(color: AppColors.darkBlue),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  auth.signOut();
                                },
                                child: Center(
                                  child: Text(
                                    "Sign Out",
                                    style: GoogleFonts.nunito(
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

Widget buildName(Users myUser) {
  return Column(
    children: [
      Text(
        myUser.userName,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      SizedBox(height: 5),
      Text(
        myUser.email,
        style: GoogleFonts.nunito(
          color: AppColors.midBlue,
          fontSize: 15,
        ),
      ),
    ],
  );
}

Widget buildBio(Users myUser) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About:",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Text(
          myUser.userBio!,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
