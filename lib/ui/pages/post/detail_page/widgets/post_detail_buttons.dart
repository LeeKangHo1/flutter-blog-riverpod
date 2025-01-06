import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailButtons extends ConsumerWidget {
  Post post;

  PostDetailButtons(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionUser sessionUser = ref.read(sessionProvider);
    // family일때는 1번으로 창고가 만들어지면, 다시 1번을 창고 만들면 SingleTon이라 new 안함
    PostDetailVM vm = ref.read(postDetailProvider(post.id!).notifier);

    // 로그인한 유저와 Post 작성 유저 비교
    if (sessionUser.id == post.user!.id!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              vm.delete(post.id!);
            },
            icon: const Icon(CupertinoIcons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PostUpdatePage(post)));
            },
            icon: const Icon(CupertinoIcons.pen),
          ),
        ],
      );
    } else {
      // 로그인한 유저랑 Post 작성자랑 다를 경우 빈 박스
      return SizedBox();
    }
  }
}
