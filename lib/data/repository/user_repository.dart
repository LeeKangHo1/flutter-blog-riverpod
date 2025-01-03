import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  const UserRepository();

  // Login관련 메서드, 구조 분해 할당 적용
  Future<(Map<String, dynamic>, String)> findByUsernameAndPassword(
      Map<String, dynamic> data) async {
    Response response = await dio.post("/login", data: data);

    Map<String, dynamic> body = response.data;
    // Logger().d(body);

    // 토큰 받기
    String accessToken = "";
    // 로그인 실패 시 토큰 없어서 터지기 때문에 try catch 로
    try {
      accessToken = response
          .headers["Authorization"]![0]; // ; 로 구분되어 있어서 제일 앞에 값([0]번지)이 필요
      // Logger().d(accessToken);
    } catch (e) {}

    // body와 토큰 동시에 보내기 위해 구조 분해 할당 사용
    return (body, accessToken);
  }

  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    // data는 필요 없음
    Response response = await dio.post(
      "/auto/login",
      options: Options(headers: {"Authorization": accessToken}),
    );
    Map<String, dynamic> body = response.data;
    return body;
  }

  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    // contentType필요 없다. my_http.dart에 설정되어 있음
    Response response = await dio.post("/join", data: data);

    // JSON오면 알아서 Map으로 바꿔줌
    Map<String, dynamic> body = response.data;
    // Logger().d(body);
    return body;
  }
}
