import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.dart';

class PostListModel {
  // 여기서 관리할 데이터 종류는 api 문서의 response 예시 참고
  bool isFirst;
  bool isLast;

  // 혹시 double값이 오는지 체크해야 한다.
  int pageNumber;
  int size;
  int totalPage;

  // 자바처럼 inner class 작성이 불가 -> model에 만든 post.dart와 user.dart를 활용
  List<Post> posts;

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        // Map<String, dynamic> 이니까 dynamic으로 인식 중이라 묵시적 형변환 후 .map 사용 가능
        posts = (map["posts"] as List<dynamic>)
            // TODO 체크, Post.fromMap에 집어 넣어서 dynamic을 Map<String, dynamic>로 묵시적 형변환
            .map((e) => Post.fromMap(e))
            .toList();
}

final postListProvider = NotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});

class PostListVM extends Notifier<PostListModel?> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    init(0);
    return null; // watch로 볼 예정이라 반환값 필요 x
  }

  Future<void> init(int page) async {
    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: page);

    // 리스트 로딩 실패 시
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    state = PostListModel.fromMap(responseBody["response"]);
  }
}
