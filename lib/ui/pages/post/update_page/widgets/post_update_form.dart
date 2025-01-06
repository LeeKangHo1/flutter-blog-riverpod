import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/post.dart';
import '../../detail_page/post_detail_vm.dart';

class PostUpdateForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  Post post;

  PostUpdateForm(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostDetailVM vm = ref.read(postDetailProvider(post.id!).notifier);
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: "${post.title}",
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            initValue: "${post.content}",
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글 수정하기",
            click: () {
              // 1. 사용자 입력값 받기

              // 2. 유효성검사 (생략)

              // 3. VM에게 위임
              vm.update(post.id!, _title.text.trim(), _content.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
