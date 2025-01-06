import 'package:flutter_blog/data/model/user.dart';
import 'package:intl/intl.dart';

class Post {
  int? id;
  String title;
  String content;

  // type 모르겠으면 final, var, dynamic 등을 붙인다.
  DateTime? createdAt;
  DateTime? updatedAt;
  int? bookmarkCount;
  User? user;

  // 화면 마다 쓰는 필드가 다를 수 있다. 이건 post_detail_vm 전용
  bool? isBookmark; // post detail에서 쓰기 위해 추가

  Post.fromMap(Map<String, dynamic> map)
      // 필드 이름 겹치는 거 없으니까 this. 생략 가능
      : id = map["id"],
        title = map["title"] ?? "",
        content = map["content"] ?? "",
        createdAt = DateFormat("yyyy-mm-dd").parse(map["createdAt"]),
        updatedAt = DateFormat("yyyy-mm-dd").parse(map["updatedAt"]),
        bookmarkCount = map["bookmarkCount"],
        isBookmark = map["isBookmark"],
        user = User.fromMap(map["user"]);
}
