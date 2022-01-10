
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:path/path.dart' as Path;

class EditPicture extends StatefulWidget {
  const EditPicture({Key? key}) : super(key: key);

  @override
  _EditPictureState createState() => _EditPictureState();
}

class _EditPictureState extends State<EditPicture> {

  AuthService auth = AuthService();
  DBService db = DBService();

  File? _imageFile;
  String? _uploadedFileURL = "";
  String? _oldImage = "";
  bool loading = false;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this._imageFile = imageTemporary);
      if(_imageFile != null){
        print('mrb');
        uploadFile(context);
      }
    } on PlatformException catch (e){
      print('Failed to pick image: $e');
    }
  }



  Future uploadFile(BuildContext context) async {

    setState(() {
      loading = true;
    });
    String fileName = Path.basename(_imageFile!.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('profilePictures/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      _uploadedFileURL = imageUrl;
    });
    print(_uploadedFileURL);

    setState(() {
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return FutureBuilder(
        future: db.userCollection.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Users userClass =
            Users.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            _oldImage = userClass.image;

            return Scaffold(
                body: ModalProgressHUD(
                  inAsyncCall: loading,
                  child: Container(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          SizedBox(height: 70),
                          //Spacer(),
                          _imageFile != null ? Image.file(
                            _imageFile!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ):
                          SizedBox(height: 10),
                          Text(
                            'Change Profile Picture',
                            style: GoogleFonts.nunito(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 35),
                          buildButton(
                            title: 'Gallery',
                            icon: Icons.image_outlined,
                            onClicked: () => pickImage(ImageSource.gallery),

                          ),
                          SizedBox(height: 20),
                          buildButton(
                            title: 'Camera',
                            icon: Icons.camera_alt_outlined,
                            onClicked: () => pickImage(ImageSource.camera),
                          ),
                          SizedBox(height: 40),
                          //Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.midBlue,
                                minimumSize: Size.fromHeight(30),

                              ),
                              child: Text("Save"),
                              onPressed: () {
                                print(_uploadedFileURL);
                                db.updateImage(
                                    _uploadedFileURL!, userClass.userToken);
                                Navigator.pop(context);
                              }
                          ),
                        ],
                      )

                  ),
                )
            );
          }
          return CircularProgressIndicator();
        });


  }
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(55),
        primary: AppColors.openBlue,
        onPrimary: AppColors.darkBlue,
        textStyle: GoogleFonts.nunito(
          fontSize: 20
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 25),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      onPressed: onClicked,
    );
