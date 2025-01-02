import 'package:flutter/cupertino.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

// GM -> Global Model -> 많은 화면에서 사용하는 모델
class SessionGM extends Notifier<SessionUser> {
  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!;

  @override
  SessionUser build() {
    return SessionUser(
        id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}

  Future<void> join() async {}

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

final sessionProvider = NotifierProvider<SessionGM, SessionUser>(() {
  return SessionGM();
});
