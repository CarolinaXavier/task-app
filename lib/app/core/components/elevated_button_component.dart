import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final String labelText;
  final Function()? onPressed;
  final double? width;
  final double? height;
  const ElevatedButtonComponent(
      {required this.labelText, this.height, this.width, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
            Color.fromRGBO(134, 135, 231, 1),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          labelText,
          style: TextStyles.instance.label.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
