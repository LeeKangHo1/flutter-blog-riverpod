import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final refreshCtrl = RefreshController();
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    init();
    return null; // watch로 볼 예정이라 반환값 필요 x
  }

  // 1. 페이지 초기화 (0페이지 리스트 로딩)
  Future<void> init() async {
    Map<String, dynamic> responseBody = await postRepository.findAll();

    // 리스트 로딩 실패 시
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // 0 페이지 일 때
    state = PostListModel.fromMap(responseBody["response"]);
    // init 메서드가 종료되면, 로딩 중 위젯 종료
    refreshCtrl.refreshCompleted();
  }

  // 2. 페이징 로드
  Future<void> nextList() async {
    PostListModel model = state!;

    // isLast -> 마지막 페이지 인가요?
    if (model.isLast) {
      // 확인용 딜레이
      await Future.delayed(Duration(milliseconds: 1000));
      refreshCtrl.loadComplete();
      return;
    }

    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 추가 로드 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    PostListModel prevModel = state!;
    PostListModel nextModel = PostListModel.fromMap(responseBody["response"]);
    print("페이징 완료");
    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
    refreshCtrl.loadComplete();
  }

  void add(String title, String content) async {
    final requestBody = {
      "title": title,
      "content": content,
    };
    Map<String, dynamic> responseBody = await postRepository.add(requestBody);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("글쓰기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    Post post = Post.fromMap(responseBody["response"]);

    // 이전 상태 받아오기
    PostListModel model = state!;

    // 깊은 복사, 새 post가 앞으로 갈지 뒤로 갈지만 정하면 됨, 뒤로 보내는 거 - [...model.posts, post]
    model.posts = [post, ...model.posts];

    // 상태 갱신
    state = state!.copyWith(posts: model.posts);
    Navigator.popAndPushNamed(mContext, "/post/list");
  }

  void update(Post post) {
    PostListModel model = state!;

    // 기존 posts 리스트를 순회하면서 id가 일치하는 경우 업데이트된 post로 교체
    model.posts = model.posts.map((p) => p.id == post.id ? post : p).toList();

    // 상태를 업데이트된 posts 리스트로 갱신
    state = state!.copyWith(posts: model.posts);
  }

  // 통신없이 상태 갱신
  void remove(int id) {
    PostListModel model = state!;

    model.posts = model.posts.where((p) => p.id != id).toList();

    // copyWith는 삭제만 반영된 posts 만 넣는 것. 나머지는 그대로 쓰는 것
    state = state!.copyWith(posts: model.posts);
  }
}
