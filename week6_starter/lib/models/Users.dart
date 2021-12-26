class Users {
  late String userId;
  late String userName;
  late bool isActive;
  late bool isPriv;
  late String? image;
  late String? userBio;
  late String userPw;
  late int numOfArticles;
  late List<dynamic> likedNews;
  late String userToken;
  late String email;
  late int numScience;
  late int numFinance;
  late int numSports;
  late int numHist;
  late int numMagazine;

  Users(String userId, String userName, bool isActive, bool isPriv, String image,
      String userBio, int numOfArticles, List<dynamic> likedNews, String userToken,
      String email, int numScience, numFinance, int numSports, numHist, numMagazine) {
    this.userId = userId;
    this.userName = userName;
    this.isActive = isActive;
    this.isPriv = isPriv;
    this.image = image;
    this.userBio = userBio;
    this.numOfArticles = numOfArticles;
    this.likedNews = likedNews;
    this.userToken = userToken;
    this.email = email;
    this.numScience = numScience;
    this.numFinance = numFinance;
    this.numSports = numSports;
    this.numHist = numHist;
    this.numMagazine = numMagazine;
  }

  Users.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['username'],
        isActive = json['isActive'],
        isPriv = json['isPriv'],
        image = json['image'],
        userBio = json['userBio'],
        numOfArticles = json['numOfArticles'],
        likedNews = json['likedNews'],
        userToken = json['userToken'],
        email = json['email'],
        numScience = json['numScience'],
        numFinance = json['numFinance'],
        numSports = json['numSports'],
        numHist = json['numHist'],
        numMagazine = json['numMagazine'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'isActive': isActive,
    'isPriv': isPriv,
    'image': image,
    'userBio': userBio,
    'numOfArticles': numOfArticles,
    'likedNews': likedNews,
    'userToken': userToken,
    'email': email,
    'numScience': numScience,
    'numFinance': numFinance,
    'numSports': numSports,
    'numHist': numHist,
    'numMagazine': numMagazine,
  };
}
