class Users {
  late String userId;
  late String userName;
  late bool isActive;
  late bool isPriv;
  late String? image;
  late String? userBio;
  late String userPw;
  late int numOfArticles;
  late List<String>? likedNews;
  late List<String>? dislikedNews;
  late String userToken;
  late String email;
  late int numScience;
  late int numFinance;
  late int numSports;
  late int numHist;
  late int numMagazine;
  late List<String>? visitedNews;

  Users(
      String userId,
      String userName,
      bool isActive,
      bool isPriv,
      String image,
      String userBio,
      int numOfArticles,
      List<String> likedNews,
      List<String> dislikedNews,
      String userToken,
      String email,
      int numScience,
      numFinance,
      int numSports,
      numHist,
      numMagazine,
      List<String> visitedNews) {
    this.userId = userId;
    this.userName = userName;
    this.isActive = isActive;
    this.isPriv = isPriv;
    this.image = image;
    this.userBio = userBio;
    this.numOfArticles = numOfArticles;
    this.likedNews = likedNews;
    this.dislikedNews = dislikedNews;
    this.userToken = userToken;
    this.email = email;
    this.numScience = numScience;
    this.numFinance = numFinance;
    this.numSports = numSports;
    this.numHist = numHist;
    this.numMagazine = numMagazine;
    this.visitedNews = visitedNews;
  }

  Users.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['username'],
        isActive = json['isActive'],
        isPriv = json['isPriv'],
        image = json['image'],
        userBio = json['userBio'],
        numOfArticles = json['numOfArticles'],
        likedNews =
            List<String>.from(json['likedNews'].map((i) => i.toString())),
        dislikedNews =
            List<String>.from(json['dislikedNews'].map((i) => i.toString())),
        userToken = json['userToken'],
        email = json['email'],
        numScience = json['numScience'],
        numFinance = json['numFinance'],
        numSports = json['numSports'],
        numHist = json['numHist'],
        numMagazine = json['numMagazine'],
        visitedNews =
            List<String>.from(json['visitedNews'].map((i) => i.toString()));

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'isActive': isActive,
        'isPriv': isPriv,
        'image': image,
        'userBio': userBio,
        'numOfArticles': numOfArticles,
        'likedNews': likedNews,
        'dislikedNews': dislikedNews,
        'userToken': userToken,
        'email': email,
        'numScience': numScience,
        'numFinance': numFinance,
        'numSports': numSports,
        'numHist': numHist,
        'numMagazine': numMagazine,
        'visitedNews': visitedNews,
      };
}
