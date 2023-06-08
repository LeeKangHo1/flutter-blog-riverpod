import 'package:flutter/material.dart';
import 'package:flutter_blog_2/views/pages/auth/join_page/join_page.dart';
import 'package:flutter_blog_2/views/pages/auth/login_page/login_page.dart';
import 'package:flutter_blog_2/views/pages/post/post_list_page/post_list_page.dart';

class Move {
  static String loginPage = "/login";
  static String joinPage = "/join";
  static String postListPage = "/post/list";
}

Map<String, Widget Function(BuildContext)> getRouters() {
  return {
    Move.loginPage: (context) => LoginPage(),
    Move.joinPage: (context) => JoinPage(),
    Move.postListPage: (context) => PostListPage(),
  };
}