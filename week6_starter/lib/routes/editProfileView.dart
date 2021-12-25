
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

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  AuthService auth = AuthService();
  DBService db = DBService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    //List<String> myList = [];

    //Users myUser = Users('lulu', true, false, 'https://www.meme-arsenal.com/memes/bb537b6f1ce1c63f139d786960ddeb72.jpg', 'bio', 0, myList , 'userToken', 'lulu@alpaca.com', 0, 0, 0, 0, 0);

    print('user id: ${user!.uid}');

    return FutureBuilder(
      future: db.userCollection.doc(user.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.connectionState == ConnectionState.done)
        {
          Users userClass = Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Scaffold(
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              physics: BouncingScrollPhysics(),
              children: [
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
                TextFieldWidget(
                  label: 'Username:',
                  text: userClass.userName,
                  onChanged:(userName) {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Email:',
                  text: userClass.email,
                  onChanged:(email) {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Bio:',
                  text: userClass.userBio!,
                  maxLines: 5,
                  onChanged:(userBio) {},
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}
