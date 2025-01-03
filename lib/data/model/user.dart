class User {
  int? id;
  String? username;
  String? imgUrl;

  // 이니셜라이저 ' : ' 사용
  User.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.username = map["username"],
        this.imgUrl = map["imgUrl"];
}
