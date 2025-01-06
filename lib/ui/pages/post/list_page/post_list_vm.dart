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

  // copyWith를 위한 기본 생성자 필요
  PostListModel({
    required this.isFirst,
    required this.isLast,
    required this.pageNumber,
    required this.size,
    required this.totalPage,
    required this.posts,
  });

  // 변화 감지를 위해서는 기존 state를 변경(state.posts.where 어쩌고)하면 안되고 복사해서 넣어야 한다.
  PostListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? pageNumber,
    int? size,
    int? totalPage,
    List<Post>? posts,
  }) {
    return PostListModel(
        isFirst: isFirst ?? this.isFirst,
        isLast: isLast ?? this.isLast,
        pageNumber: pageNumber ?? this.pageNumber,
        size: size ?? this.size,
        totalPage: totalPage ?? this.totalPage,
        posts: posts ?? this.posts);
  }

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        // Map<String, dynamic> 이니까 dynamic으로 인식 중이라 묵시적 형변환 후 .map 사용 가능
        posts = (map["posts"] as List<dynamic>)
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
    // Logger().d("통신 1번");
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

  // 통신없이 상태 갱신
  void remove(int id) {
    PostListModel model = state!;

    model.posts = model.posts.where((p) => p.id != id).toList();

    // copyWith는 삭제만 반영된 posts 만 넣는 것. 나머지는 그대로 쓰는 것
    state = state!.copyWith(posts: model.posts);
  }

  void add(Post post) {
    PostListModel model = state!;

    // 깊은 복사, 새 post가 앞으로 갈지 뒤로 갈지만 정하면 됨, 뒤로 보내는 거 - [...model.posts, post]
    model.posts = [post, ...model.posts];

    // copyWith는 삭제만 반영된 posts 만 넣는 것. 나머지는 그대로 쓰는 것
    state = state!.copyWith(posts: model.posts);
  }

// void search(int id) {
//   PostListModel model = state!;
//
//   model.posts = model.posts.where((p) => p.id == id).toList();
//
//   state = state!.copyWith(posts: model.posts);
// }
//
// void biggerThenSearch(int id) {
//   PostListModel model = state!;
//
//   model.posts = model.posts.where((p) => p.id! > id).toList();
//
//   state = state!.copyWith(posts: model.posts);
// }
}
