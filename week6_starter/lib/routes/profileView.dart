import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week6_starter/routes/OwnBlogFeed.dart';
import 'package:week6_starter/routes/profileViewCounts.dart';
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

import 'likedNewsView.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.analytics, required this.observer}) : super(key: key);
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
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users userClass = Users.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            if (user.isAnonymous) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.darkBlue,
                  automaticallyImplyLeading: false,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.midBlue,
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Center(
                              child:
                              Text("Sign Up", style: GoogleFonts.nunito(
                                color: AppColors.whiteBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.midBlue,
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Center(
                              child: Text("Login",
                                style: GoogleFonts.nunito(
                                  color: AppColors.whiteBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.darkBlue,
                  automaticallyImplyLeading: false,
                ),

                body: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Column(
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
                                  MaterialPageRoute(builder: (context) =>
                                      EditProfileView(
                                          analytics: widget.analytics,
                                          observer: widget.observer)),
                                )
                                    .then((value) => {setState(() {})});
                              }
                            }),
                        SizedBox(height: 20),
                        buildName(userClass),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                  indent: 3,
                                  endIndent: 3,
                                  thickness: 2,
                                  color: AppColors.darkBlue,
                                )),
                          ],
                        ),
                        buildBio(userClass),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                  indent: 3,
                                  endIndent: 3,
                                  thickness: 2,
                                  color: AppColors.darkBlue,
                                )),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.midBlue,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (user.isAnonymous) {
                                          return;
                                        } else {
                                          print("PUSHED");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LikedNews(
                                                      userId: userClass.userId,
                                                      observer: widget.observer,
                                                      analytics: widget
                                                          .analytics,),
                                              ));
                                        }
                                      },
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.midBlue,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (user.isAnonymous) {
                                          return;
                                        } else {
                                          print("PUSHED");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OwnBlogFeedView(
                                                      userId: userClass.userId,
                                                      observer: widget.observer,
                                                      analytics: widget
                                                          .analytics,),
                                              ));
                                        }
                                      },
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.midBlue,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (user.isAnonymous) {
                                          return;
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileViewCounts(
                                                        observer: widget
                                                            .observer,
                                                        analytics: widget
                                                            .analytics,
                                                        numOfArticles: userClass
                                                            .numOfArticles,
                                                        numHist: userClass
                                                            .numHist,
                                                        numFinance: userClass
                                                            .numFinance,
                                                        numMagazine: userClass
                                                            .numMagazine,
                                                        numScience: userClass
                                                            .numScience,
                                                        numSports: userClass
                                                            .numSports),
                                              ));
                                        }
                                      },
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
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.midBlue,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        if (user.isAnonymous) {
                                          return;
                                        } else {
                                          db.makeAccountPrivate(
                                              userClass.userToken,
                                              !userClass.isPriv);
                                          setState(() {});
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          userClass.isPriv
                                              ? "Make Account Public"
                                              : "Make Account Private",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColors.darkBlue),
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
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColors.darkBlue),
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (user.isAnonymous) {
                                          return;
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Which action do you want to perform?"),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      "Delete Account",
                                                      style: GoogleFonts.nunito(
                                                          color: Color(
                                                              0xFFA01B10),
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 20),),
                                                    onPressed: () async {
                                                      print(
                                                          "userclass userId: " +
                                                              userClass.userId);
                                                      await db.deleteUser(
                                                          userClass.userId);
                                                      await auth.deleteUser();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      "Deactivate Account",
                                                      style: GoogleFonts.nunito(
                                                          color: Color(
                                                              0xFF0B4BAD),
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 20),),
                                                    onPressed: () async {
                                                      await db.deactivateUser(
                                                          userClass.userId,
                                                          false);
                                                      await auth.signOut();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Delete/Deactivate Account",
                                          style: GoogleFonts.nunito(
                                              color: Color(0xFFA01B10),
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
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          }
          return CircularProgressIndicator();
        });
  }
}

Widget buildName(Users myUser) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myUser.isPriv
              ? Icon(
            Icons.lock_rounded,
            size: 25,
          )
              : Container(),
          Text(
            myUser.userName,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
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
