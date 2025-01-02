import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  const UserRepository();

  // 일단 Future를 적고 본다.
  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    // contentType필요 없다. my_http.dart에 설정되어 있음
    Response response = await dio.post("/join", data: data);

    // JSON오면 알아서 Map으로 바꿔줌
    Map<String, dynamic> body = response.data;
    // Logger().d(body);
    return body;
  }
}
