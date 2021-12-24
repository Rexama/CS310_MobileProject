import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  @override
  Widget build(BuildContext context) {
    List<String> myList = [];
    Users myUser = Users('lulu', true, false, 'https://www.meme-arsenal.com/memes/bb537b6f1ce1c63f139d786960ddeb72.jpg', 'bio', 0, myList , 'userToken', 'lulu@alpaca.com', 0, 0, 0, 0, 0);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: myUser.image,
            isEdit: true,
            onClicked: () async{},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Username:',
            text: myUser.userName,
            onChanged:(userName) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email:',
            text: myUser.email,
            onChanged:(email) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Bio:',
            text: myUser.userBio!,
            maxLines: 5,
            onChanged:(userBio) {},
          ),
        ],
      ),
    );
  }
}
