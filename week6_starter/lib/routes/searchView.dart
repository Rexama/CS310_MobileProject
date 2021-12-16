import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/models/News.dart';
import 'package:week6_starter/services/auth.dart';
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
    for (News news in allNews) {
      if (_isContentSelected && news.content.contains(keyword)) {
        results.add(news);
      }
      if (_isTagSelected && news.category.contains(keyword)) {
        results.add(news);
      }
      if (_isTitleSelected && news.title.contains(keyword)) {
        results.add(news);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteBlue,
        appBar: AppBar(
          backgroundColor: AppColors.darkestBlue,
          title: _appBarTitle,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: _searchPressed,
              icon: _searchIcon,
            )
          ],
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
                        onPressed: () => setState(
                            () => _isTitleSelected = !_isTitleSelected),
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
                        onPressed: () =>
                            setState(() => _isTagSelected = !_isTagSelected),
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
                        onPressed: () => setState(
                            () => _isContentSelected = !_isContentSelected),
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
                child: results == null
                    ? Container()
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: FlutterLogo(size: 72.0), //ImageNetwork
                              title: Text(
                                results[index].title,
                                style: newsTextBoldDark,
                              ),
                              subtitle: Text(
                                results[index].subtitle,
                                style: GoogleFonts.robotoSlab(
                                    color: AppColors.darkBlue, fontSize: 15),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }

  onSearchTextChanged(String text) async {
    results.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
  }
}
