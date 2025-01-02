import 'package:flutter_blog/data/repository/user_repository.dart';

void main() async {
  UserRepository userRepository = UserRepository();

  // 1. given
  final requestBody = {
    "username": "user",
    "email": "email@nate.com",
    "password": "password",
  };

  // 2. when
  Map<String, dynamic> responseBody = await userRepository.save(requestBody);

  // 3. then -> save 안에 Logger().d(body);
}
