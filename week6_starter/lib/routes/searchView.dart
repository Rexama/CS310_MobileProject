import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/models/News.dart';
import 'package:week6_starter/services/auth.dart';
import 'package:week6_starter/services/db.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:week6_starter/utils/styles.dart';

class SearchView extends StatefulWidget {
  @override
  const SearchView({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _SearchView createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  AuthService auth = AuthService();

  final firestoreInstance = FirebaseFirestore.instance;

  bool _isTitleSelected = false;
  bool _isContentSelected = false;
  bool _isTagSelected = false;

  String orderBy = '';

  final TextEditingController _filter = new TextEditingController();

  List<News> results = []; //filtered news
  List<News> allNews = []; //unfiltered news (all data from db)
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('');

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          onChanged: (text) {
            getFilteredNews(text);
          },
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(
              Icons.search,
              color: AppColors.whiteBlue,
            ),
            hintText: 'Search...',
            hintStyle: newsText,
          ),
          style: newsText,
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('');
        results = [];
        _filter.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getNews();
  }

  Future<Null> getNews() async {
    firestoreInstance.collection("news").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        News tempNew = News.fromJson(result.data());
        allNews.add(tempNew);
      });
    });
  }

  getFilteredNews(String keyword) {
    setState(() {
      results.clear();
      for (News news in allNews) {
        if (_isContentSelected &&
            keyword.isNotEmpty &&
            news.content.contains(keyword)) {
          results.add(news);
        } else if (_isTagSelected && keyword.isNotEmpty) {
          for (String category in news.category) {
            if (category.contains(keyword)) {
              results.add(news);
              break;
            }
          }
        } else if (_isTitleSelected &&
            keyword.isNotEmpty &&
            news.title.contains(keyword)) {
          results.add(news);
        }
      }
      if (orderBy != '') {
        if (orderBy.substring(0, orderBy.length - 4) == 'Title') {
          results.sort((a, b) {
            return a.title
                .toString()
                .toLowerCase()
                .compareTo(b.title.toString().toLowerCase());
          });
        } else if (orderBy.substring(0, orderBy.length - 4) == 'Subtitle') {
          results.sort((a, b) {
            return a.subtitle
                .toString()
                .toLowerCase()
                .compareTo(b.subtitle.toString().toLowerCase());
          });
        } else if (orderBy.substring(0, orderBy.length - 4) == 'Like') {
          results.sort((a, b) {
            return a.subtitle
                .toString()
                .toLowerCase()
                .compareTo(b.subtitle.toString().toLowerCase());
          });
        } else if (orderBy.substring(0, orderBy.length - 4) == 'Dislike') {
          results.sort((a, b) {
            return a.subtitle
                .toString()
                .toLowerCase()
                .compareTo(b.subtitle.toString().toLowerCase());
          });
        } else if (orderBy.substring(0, orderBy.length - 4) == 'Comment') {
          results.sort((a, b) {
            return a.subtitle
                .toString()
                .toLowerCase()
                .compareTo(b.subtitle.toString().toLowerCase());
          });
        }

        if (orderBy.substring(orderBy.length - 4) == 'Ascc') {
          results = results.reversed.toList();
        }
      }
    });
    print("s");
    print(results[0].image.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteBlue,
        appBar: AppBar(
          backgroundColor: AppColors.darkestBlue,
          title: _appBarTitle,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.list),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: _searchPressed,
              icon: _searchIcon,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 70,
                child: DrawerHeader(
                  child: Text(
                    "Sort by",
                    style: newsTextBold,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Title - Alphabetical ↓",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'TitleDesc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Title - Alphabetical ↑",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'TitleAscc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Subtitle - Alphabetical ↓",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'SubtitleDesc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Subtitle - Alphabetical ↑",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'SubtitleAscc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Like Count ↓",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'LikeDesc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Like Count ↑",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'LikeAscc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Dislike Count ↓",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'DislikeDesc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Dislike Count ↑",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'DislikeAscc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Comment Count ↓",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'CommentDesc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
              ListTile(
                title: Text(
                  "Comment Count ↑",
                  style: GoogleFonts.robotoSlab(
                    color: AppColors.darkestBlue,
                    fontSize: 17.5,
                  ),
                ),
                leading: Radio(
                  value: 'CommentAscc',
                  groupValue: orderBy,
                  onChanged: (value) {
                    setState(() {
                      orderBy = value as String;
                    });
                    getFilteredNews(_filter.text);
                  },
                  activeColor: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: Dimen.regularPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.0,
                child: Container(
                  alignment: Alignment.center,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _isTitleSelected = !_isTitleSelected);
                          getFilteredNews(_filter.text);
                        },
                        child: Text(
                          'title',
                          style: _isTitleSelected ? newsText : newsTextDark,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: _isTitleSelected
                              ? AppColors.darkBlue
                              : AppColors.openBlue,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _isTagSelected = !_isTagSelected);
                          getFilteredNews(_filter.text);
                        },
                        child: Text(
                          'tag',
                          style: _isTagSelected ? newsText : newsTextDark,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: _isTagSelected
                              ? AppColors.darkBlue
                              : AppColors.openBlue,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                                  () => _isContentSelected = !_isContentSelected);
                          getFilteredNews(_filter.text);
                        },
                        child: Text(
                          'content',
                          style: _isContentSelected ? newsText : newsTextDark,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: _isContentSelected
                              ? AppColors.darkBlue
                              : AppColors.openBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: results.isEmpty
                    ? Container()
                    : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 200,
                      child: Card(
                        child: Container(
                          height: 200,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: results[index].image == null
                                        ? Icon(
                                      Icons.image_not_supported,
                                      size: 75,
                                    )
                                        : Image.network(
                                      results[index].image
                                      as String,
                                      width: 75,
                                      height: 75,
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          results[index].title.length > 20
                                              ? results[index]
                                              .title
                                              .substring(0, 18) +
                                              '..'
                                              : results[index].title,
                                          style: newsTextBoldDark,
                                        ),
                                        subtitle: Text(
                                          results[index].subtitle.length >
                                              125
                                              ? results[index]
                                              .subtitle
                                              .substring(0, 122) +
                                              '...'
                                              : results[index].subtitle,
                                          style: GoogleFonts.robotoSlab(
                                            color: AppColors.darkestBlue,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.thumb_up,
                                            color: Color(0xff1b6609),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            results[index]
                                                .numLike
                                                .toString(),
                                            style: GoogleFonts.robotoSlab(
                                              color: AppColors.darkBlue,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            Icons.thumb_down,
                                            color: Color(0xff7d060a),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            results[index]
                                                .numDislike
                                                .toString(),
                                            style: GoogleFonts.robotoSlab(
                                              color: AppColors.darkBlue,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
