import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/models/News.dart';
import 'package:week6_starter/routes/newsView.dart';
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
  final AuthService auth = AuthService();
  final DBService db = DBService();

  bool _isTitleSelected = false;
  bool _isContentSelected = false;
  bool _isTagSelected = false;

  String orderBy = '';

  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('');

  List<News> results = []; //filtered news
  List<News> allNews = []; //unfiltered news (all data from db)

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

    db.getNews(allNews);
  }

  getFilteredNews(String keyword) {
    setState(() {
      results.clear();
      for (News news in allNews) {
        if (_isContentSelected &&
            keyword.isNotEmpty &&
            news.content.toLowerCase().contains(keyword.toLowerCase()) &&
            !results.contains(news)) {
          results.add(news);
        }
        if (_isTagSelected && keyword.isNotEmpty && !results.contains(news)) {
          for (String category in news.category) {
            if (category.contains(keyword.toLowerCase())) {
              results.add(news);
              break;
            }
          }
        }
        if (_isTitleSelected &&
            keyword.isNotEmpty &&
            news.title.toLowerCase().contains(keyword.toLowerCase()) &&
            !results.contains(news)) {
          results.add(news);
        }
      }
      if (orderBy != '') {
        results.sort((a, b) {
          return a
              .toJson()[orderBy.substring(0, orderBy.length - 4)]
              .compareTo(b.toJson()[orderBy.substring(0, orderBy.length - 4)]);
        });
        if (orderBy.substring(orderBy.length - 4) == 'Desc') {
          results = results.reversed.toList();
        }
      }
    });
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
              RadioListElement('Title - Alphabetical ↓', 'titleAscc'),
              RadioListElement('Title - Alphabetical ↑', 'titleDesc'),
              RadioListElement('Subtitle - Alphabetical ↓', 'subtitleAscc'),
              RadioListElement('Subtitle - Alphabetical ↑', 'subtitleDesc'),
              RadioListElement('Like Count ↓', 'numLikeDesc'),
              RadioListElement('Like Count ↑', 'numLikeAscc'),
              RadioListElement('Dislike Count ↓', 'numDislikeDesc'),
              RadioListElement('Dislike Count ↑', 'numDislikeAscc'),
              RadioListElement('Newest', 'createdOnDesc'),
              RadioListElement('Oldest', 'createdOnAscc'),
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
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsView(
                                          analytics: widget.analytics,
                                          observer: widget.observer,
                                          content: allNews[index]),
                                ),
                              );
                            },
                            child:
                              Container(
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
                              ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }

  ListTile RadioListElement(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.robotoSlab(
          color: AppColors.darkestBlue,
          fontSize: 17.5,
        ),
      ),
      leading: Radio(
        value: value,
        groupValue: orderBy,
        onChanged: (value) {
          setState(() {
            orderBy = value as String;
          });
          getFilteredNews(_filter.text);
        },
        activeColor: AppColors.darkBlue,
      ),
    );
  }
}
