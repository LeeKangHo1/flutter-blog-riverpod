import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

// GVM -> Global View Model -> 많은 화면에서 사용하는 모델
class SessionGVM extends Notifier<SessionUser> {
  // main.dart에서 설정한 navigatorKey 를 가져온다.
  final mContext = navigatorKey
      .currentContext!; // currentContext -> 화면 없으면 null일 수 있다. 근데 여기서는 절대 null 아니니까 !적음
  UserRepository userRepository = const UserRepository();

  @override
  SessionUser build() {
    return SessionUser(
        id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}

  Future<void> join(String username, String email, String password) async {
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };
    Map<String, dynamic> responseBody = await userRepository.save(requestBody);
    // 여기서 성공, 실패 처리
    if (!responseBody["success"]) {
      // BuildContext가 있어야 alert를 띄우든 화면 전환을 하든 한다.
      // main.dart에서 GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      // navigatorKey: navigatorKey 설정 -> mContext로 받아옴

      // 로그인 실패 시 -> test는 중복 id 넣으면 된다.
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // 가입 성공 시 로그인 페이지로
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {}

  // 휴대폰에 저장된 토큰을 스프링 서버로 보내고 인증되면(코드200?) 자동 로그인
  Future<void> autoLogin() async {
    Future.delayed(
      Duration(seconds: 3),
      () {
        // 곰돌이 화면에서 3초 대기 후 "/login"으로 이동
        Navigator.popAndPushNamed(mContext, "/login");
      },
    );
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
