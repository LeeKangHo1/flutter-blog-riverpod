import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class PostRepository {
  const PostRepository();

  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    // /api/post?page=0로 적지 말고 쿼리스트링은 queryParameters에
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    Map<String, dynamic> body = response.data;
    return body;
    // TODO 테스트 코드 작성
  }
}
