import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/post.dart';
import '../../../../main.dart';

class PostDetailModel {
  Post post;

  PostDetailModel({required this.post});

  PostDetailModel copyWith({Post? post}) {
    return PostDetailModel(post: post ?? this.post);
  }

  PostDetailModel.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}

// .autoDispose 를 쓸 경우 화면 파괴시에 창고와 같이 파괴
final postDetailProvider = NotifierProvider.family
    .autoDispose<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

class PostDetailVM extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostDetailModel? build(id) {
    init(id);
    return null;
  }

  Future<void> init(int id) async {
    Map<String, dynamic> responseBody = await postRepository.findById(id);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    state = PostDetailModel.fromMap(responseBody["response"]);
  }

  Future<void> delete(int id) async {
    Map<String, dynamic> responseBody = await postRepository.delete(id);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 삭제 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // PostListVM의 상태를 변경 - 통신을 1번 더 하는 방식 (비추), 확인해보려면 init()에 Logger찍어보면 됨
    // ref.read(postListProvider.notifier).init(0);

    // detail은 autoDispose니까 PostListVM의 상태를 변경, 통신이 아니니까 await 필요 없음
    ref.read(postListProvider.notifier).remove(id);

    // EventBus Notifier -> 삭제했어!! -> 이건 이번 프로젝트 쓰지마. 하던 거 하다 보면 왜 필요한지 알게 될 것

    // 화면 파괴시 vm이 autoDispose 됨
    Navigator.pop(mContext);
  }

  Future<void> update(int id, String title, String content) async {
    final requestBody = {
      "title": title,
      "content": content,
    };
    Map<String, dynamic> responseBody =
        await postRepository.update(id, requestBody);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 수정 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    state = PostDetailModel.fromMap(responseBody["response"]);
    ref
        .read(postListProvider.notifier)
        .update(Post.fromMap(responseBody["response"]));

    Navigator.pop(mContext);
  }

  Future<void> add(String title, String content) async {
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
    ref
        .read(postListProvider.notifier)
        .add(Post.fromMap(responseBody["response"]));

    Navigator.popAndPushNamed(mContext, "/post/list");
  }
}
