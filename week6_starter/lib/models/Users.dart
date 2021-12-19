class Users {
  late String userName;
  late bool isActive;
  late bool isPriv;
  late String? image;
  late String? userBio;
  late String userPw;
  late int numOfArticles;
  late List<String>? likedNews;
  late String userToken;
  late String email;

  Users( String userName, bool isActive, bool isPriv, String image,
      String userBio, int numOfArticles, List<String> likedNews, String userToken,
      String email) {
    this.userName = userName;
    this.isActive = isActive;
    this.isPriv = isPriv;
    this.image = image;
    this.userBio = userBio;
    this.numOfArticles = numOfArticles;
    this.likedNews = likedNews;
    this.userToken = userToken;
    this.email = email;
  }

  Users.fromJson(Map<String, dynamic> json)
      : userName = json['username'],
        isActive = json['isActive'],
        isPriv = json['isPriv'],
        image = json['image'],
        userBio = json['userBio'],
        numOfArticles = json['numOfArticles'],
        likedNews = json['likedNews'],
        userToken = json['userToken'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'isActive': isActive,
    'isPriv': isPriv,
    'image': image,
    'userBio': userBio,
    'numOfArticles': numOfArticles,
    'likedNews': likedNews,
    'userToken': userToken,
    'email': email,
  };
}
