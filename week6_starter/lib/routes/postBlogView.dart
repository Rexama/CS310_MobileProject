
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/styles.dart';

class PostBlogFeedView extends StatefulWidget {
  @override
  const PostBlogFeedView({Key? key, required this.analytics, required this.observer, required this.userId})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String userId;

  _PostBlogFeedView createState() => _PostBlogFeedView();
}

class _PostBlogFeedView extends State<PostBlogFeedView> {
  AuthService auth = AuthService();
  DBService db = DBService();

  List<bool> _selected = [false, false, false, false, false];
  List<String> _categoryList = ["Science", "Finance", "Sports", "History", "Magazine"];

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        leading: IconButton(
          onPressed: () {
            auth.signOut();
          },
          icon: Icon(Icons.logout),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Color.fromRGBO(21, 32, 43, 1.0), border: Border(bottom: BorderSide())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.whiteBlue,
                        hintText: "enter title here",
                        hintStyle: GoogleFonts.robotoSlab(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    Container(
                      height: 25,
                    ),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.whiteBlue,
                        hintText: "share your thoughts\n\n\n\n\n",
                        hintStyle: GoogleFonts.robotoSlab(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    Container(
                      height: 25,
                    ),
                    TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.whiteBlue,
                        hintText: "imageUrl",
                        hintStyle: GoogleFonts.robotoSlab(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    Container(
                      height: 25,
                    ),
                    SizedBox(
                      height: 30.0,
                      child: Container(
                        alignment: Alignment.center,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            categorySelector(0),
                            SizedBox(
                              width: 30,
                            ),
                            categorySelector(1),
                            SizedBox(
                              width: 30,
                            ),
                            categorySelector(2),
                            SizedBox(
                              width: 30,
                            ),
                            categorySelector(3),
                            SizedBox(
                              width: 30,
                            ),
                            categorySelector(4),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                      child: ElevatedButton(
                        child: Text(
                          "SEND",
                          style: newsTextDark,
                        ),
                        style: ElevatedButton.styleFrom(primary: Color(0xFF1C7120)),
                        onPressed: () {
                          List<String> _categoriesSelected = [];
                          DateTime now = new DateTime.now();
                          for (int i = 0; i < 5; i++) {
                            if (_selected[i]) {
                              _categoriesSelected.add(_categoryList[i]);
                            }
                          }
                          db.postBlogItem(_titleController.text, _contentController.text, _imageUrlController.text,
                                  _categoriesSelected, now, widget.userId.toString())
                              .catchError((error) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(error),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton categorySelector(int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() => _selected[index] = !_selected[index]);
      },
      child: Text(
        _categoryList[index],
        style: _selected[index] ? newsText : newsTextDark,
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        primary: _selected[index] ? AppColors.darkBlue : AppColors.openBlue,
      ),
    );
  }
}
