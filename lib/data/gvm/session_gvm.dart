import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin = false});
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

  // async 함수는 Future 붙여. 문법이라고 생각해
  Future<void> login(String username, String password) async {
    final requestBody = {
      "username": username,
      "password": password,
    };

    // 구조 분해 할당으로 return
    // final (Map<String, dynamic> responseBody, String accessToken) =
    final (responseBody, accessToken) =
        await userRepository.findByUsernameAndPassword(requestBody);

    if (!responseBody["success"]) {
      // 로그인 실패
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // 여기서 부터 트랜잭션 시작

    // 1. 토큰을 Storage 저장 -> Storage는 휴대폰 껏다 켜도 데이터 보존 -> flutter_secure_storage 라이브러리 필요
    await secureStorage.write(
        key: "accessToken", value: accessToken); // I/O -> 오래 걸린다.

    // 2. SessionUser 갱신
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    // 3. Dio 토큰 세팅, dio는 메모리에 저장이라 await 필요 없음 -> 껐다 키면 없어지는 데이터
    dio.options.headers["Authorization"] = accessToken;

    // 트랜잭션 끝
    Navigator.popAndPushNamed(mContext, "/post/list");
  }

  // 0. 이 메서드가 실행되는 시점에는 SessionUser가 있을 수가 없다.
  Future<void> autoLogin() async {
    // 자동 로그인 response에 토큰이 없다 -> secureStorage에 있으니까. 물론 주는 경우 있는데 그러면 기존 토큰 덮어씌우기

    // 1. 디바이스에서 토큰 가져오기 (오래 걸리는 작업)
    String? accessToken = await secureStorage.read(key: "accessToken");
    // Logger().d(accessToken);

    // 토큰 없을 경우 로그인 화면으로
    if (accessToken == null) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    // 2. 로그인 통신
    Map<String, dynamic> responseBody =
        await userRepository.autoLogin(accessToken);

    // 로그인 실패 시
    if (!responseBody["success"]) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    // 3. 로그인 성공 시 SessionUser 상태 업데이트
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    dio.options.headers["Authorization"] = accessToken;

    Navigator.popAndPushNamed(mContext, "/post/list");
  }

  Future<void> join(String username, String email, String password) async {
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };
    Map<String, dynamic> responseBody = await userRepository.save(requestBody);

    // 여기서 성공, 실패 처리
    if (!responseBody["success"]) {
      // 회원가입 실패 test는 중복 id 넣으면 된다.
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // 가입 성공 시 로그인 페이지로
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {
    // 1. 디바이스 토큰 삭제
    await secureStorage.delete(key: "accessToken");
    // Logger().d(state.username);

    // 2. 상태 갱신
    state = SessionUser(
        // id, username, accessToken 안 넣으면 null, isLogin도 디폴트가 false
        //   id: data["id"],
        //   username: data["username"],
        //   accessToken: accessToken,
        //   isLogin: false
        );
    // Logger().d(state.username);

    // 3. dio 갱신
    dio.options.headers["Authorization"] = "";

    // 화면 다 파괴하고, LoginPage 가기
    Navigator.pushNamedAndRemoveUntil(
      mContext,
      "/login",
      (route) => false,
    );
    // Navigator.popAndPushNamed(mContext, "/post/list");
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
