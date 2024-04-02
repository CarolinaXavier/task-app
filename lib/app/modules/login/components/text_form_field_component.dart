import 'package:flutter/material.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';

class TextFormFieldComponent extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const TextFormFieldComponent({super.key, required this.labelText, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyles.instance.label,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color.fromRGBO(29, 29, 29, 1),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color.fromRGBO(151, 151, 151, 1),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
