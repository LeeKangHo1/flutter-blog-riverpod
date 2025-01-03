import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailModel {
  // post_list_vm에 쓰는 것 재활용 -> 필드 이름이 대부분 같으니까
  Post? post;
}

final postDetailProvider = NotifierProvider<PostDetailVM, PostDetailModel?>(() {
  return PostDetailVM();
});

class PostDetailVM extends Notifier<PostDetailModel?> {
  @override
  PostDetailModel? build() {
    init();
    return null;
  }

  Future<void> init() async {
    // TODO
  }
}
