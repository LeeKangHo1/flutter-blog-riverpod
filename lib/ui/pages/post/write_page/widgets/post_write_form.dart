import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detail_page/post_detail_vm.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 에러 방지를 위한 아무 숫자 집어 넣음
    final postId = 1;
    PostDetailVM vm = ref.read(postDetailProvider(postId).notifier);
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글쓰기",
            click: () {
              // 1. 사용자 입력값 받기

              // 2. 유효성검사 (생략)

              // 3. VM에게 위임
              vm.add(_title.text.trim(), _content.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
