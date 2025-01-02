import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  const UserRepository();

  // 일단 Future를 적고 본다.
  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    // contentType필요 없다. my_http.dart에 설정되어 있음
    Response response = await dio.post("/join", data: data);

    // 근데 dio는 200 아니면 예외 터트림 -> my_http.dart에서 validateStatus: (status) => true 설정해야 한다.
    // if (response.statusCode != 200) {
    //    비즈니스 로직 작성 -> 근데 repository 권한이 아니야 -> VM에서 처리
    // }

    // JSON오면 알아서 Map으로 바꿔줌
    Map<String, dynamic> body = response.data;
    // TODO: test 코드 작성 - 직접 해보기
    Logger().d(body);
    return body;
  }
}
