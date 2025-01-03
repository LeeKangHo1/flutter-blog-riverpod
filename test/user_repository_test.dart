import 'package:flutter_blog/data/repository/user_repository.dart';

void main() async {
  TestRepository testRepository = TestRepository();

  await testRepository.testFindByUsernameAndPassword();
  // await testRepository.testSave();
}

class TestRepository {
  UserRepository userRepository = const UserRepository();

  Future<void> testSave() async {
    // 1. given
    final requestBody = {
      "username": "user",
      "email": "email@nate.com",
      "password": "password",
    };

    // 2. when
    Map<String, dynamic> responseBody = await userRepository.save(requestBody);

    // 3. then -> save 안에 Logger().d(body);
    // Logger().d(responseBody); // test 쪽이든 repository든 한 쪽에만 적으면 된다.
  }

  Future<void> testFindByUsernameAndPassword() async {
    // 1. given
    final requestBody = {
      "username": "ssar1",
      "password": "1234",
    };

    // 2. when
    (Map<String, dynamic>, String) responseBody =
        await userRepository.findByUsernameAndPassword(requestBody);

    // 3. then -> Logger
  }
}
