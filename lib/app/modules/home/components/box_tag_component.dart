import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';

class BoxTagComponent extends StatelessWidget {
  final String labelText;
  final double? height;
  final double? width;
  const BoxTagComponent({required this.labelText, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      width: width ?? 90,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.21),
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Row(
        children: [
          Text(
           labelText,
            style: TextStyles.instance.label,
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 30,
            color: Colors.white.withOpacity(0.87),
          )
        ],
      ),
    );
  }
}
