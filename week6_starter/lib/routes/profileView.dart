import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
    List<String> myList = [];
    Users myUser = Users('lulu', true, false, 'https://www.meme-arsenal.com/memes/bb537b6f1ce1c63f139d786960ddeb72.jpg', 'bio', 0, myList , 'userToken', 'lulu@alpaca.com', 0, 0, 0, 0, 0);

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 30),
          ProfileWidget(
            imagePath: myUser.image,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileView()),
              );
            }
          ),
          SizedBox(height: 20),
          buildName(myUser),
          Expanded(child: Divider(
            color: AppColors.darkBlue,
          )),
          buildBio(myUser),
          Expanded(child: Divider(
            color: AppColors.darkBlue,
          )),
        ],
      ),
    );
  }
}

Widget buildName(Users myUser){
  return Column(
    children: [
      Text(
        myUser.userName,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      SizedBox(height: 5)
,      Text(
        myUser.email,
        style: GoogleFonts.nunito(
        color: AppColors.midBlue,
        fontSize: 15,
        ),
      ),
    ],
  );
}

Widget buildBio(Users myUser){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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


