import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_body.dart';

class PostDetailPage extends StatelessWidget {
  int postId;

  PostDetailPage(this.postId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // 데이터 이동을 많이 해야 하면 GVM에 저장하는 게 좋은데 몇 번 안되니까
      body: PostDetailBody(postId),
    );
  }
}
