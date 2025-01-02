import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_logo.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/gvm/session_gvm.dart';

class JoinBody extends ConsumerWidget {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 회원가입, 로그인은 watch 할 필요 없다.
    SessionGVM gvm = ref.read(sessionProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const CustomLogo("Blog"),
          CustomAuthTextFormField(
            text: "Username",
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Email",
            controller: _email,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "회원가입",
            click: () {
              // 1. 사용자 입력값 받기

              // 2. 유효성검사 (생략)

              // 3. GVM에게 위임
              // 원래는 입력값 받아서 유효성 검사하고 여기에 넣어야 한다.
              gvm.join(_username.text.trim(), _email.text.trim(),
                  _password.text.trim());
            },
          ),
          CustomTextButton(
            text: "로그인 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
