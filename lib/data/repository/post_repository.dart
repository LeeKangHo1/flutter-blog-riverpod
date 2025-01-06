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
  }

  Future<Map<String, dynamic>> findById(int id) async {
    Response response = await dio.get("/api/post/${id}");
    Map<String, dynamic> body = response.data;
    return body;
  }

  Future<Map<String, dynamic>> delete(int id) async {
    Response response = await dio.delete("/api/post/${id}");
    Map<String, dynamic> body = response.data;
    return body;
  }

  Future<Map<String, dynamic>> update(int id, Map<String, dynamic> data) async {
    Response response = await dio.put("/api/post/${id}", data: data);
    Map<String, dynamic> body = response.data;
    return body;
  }

  Future<Map<String, dynamic>> add(Map<String, dynamic> data) async {
    Response response = await dio.post("/api/post", data: data);

    Map<String, dynamic> body = response.data;
    return body;
  }
}
