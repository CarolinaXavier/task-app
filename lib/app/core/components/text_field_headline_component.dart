import 'package:flutter/material.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/login/components/text_form_field_component.dart';

class TextFieldHeadlineComponent extends StatelessWidget {
  final String headlineText;
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  const TextFieldHeadlineComponent(
      {required this.headlineText,
      required this.labelText,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headlineText,
          style: TextStyles.instance.label,
        ),
        const SizedBox(height: 16),
        TextFormFieldComponent(
          labelText: labelText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
