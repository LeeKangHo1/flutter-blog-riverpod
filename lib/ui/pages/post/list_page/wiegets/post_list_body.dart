import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider);

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      print("body 로드 완료");
      return ListView.separated(
        itemCount: model.posts.length,
        itemBuilder: (context, index) {
          // 클릭 가능하도록 InkWell
          return InkWell(
            onTap: () {
              // push
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PostDetailPage()));
            },
            child: PostListItem(post: model.posts[index]),
          );
        },
        // TODO 지우면 어떻게 되는지 테스트, ListView.separated에서 사용 가능, row 사이 border 생성
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
