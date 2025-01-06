import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  int postId;

  PostDetailBody(this.postId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FutureProvider, StreamProvider, StateProvider, NotifierProvider, asyncNotifierProvider(vm에서 비즈니스로직 처리하려고. 이거 쓰면 여기서 해야 함)
    // 우린 NotifierProvider 하나만 쓴다.
    PostDetailModel? model = ref.watch(postDetailProvider(postId));

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          PostDetailTitle("${model.post.title}"),
          const SizedBox(height: largeGap),
          PostDetailProfile(model.post),
          // postId가 아니라 post 통으로 보낸 이유 -> update때문
          PostDetailButtons(model.post),
          const Divider(),
          const SizedBox(height: largeGap),
          PostDetailContent("${model.post.content}"),
        ],
      ),
    );
  }
}
