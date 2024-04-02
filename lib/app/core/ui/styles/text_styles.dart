import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();
  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  TextStyle get titulo => GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ColorsApp.instance.secondary,
      );

  TextStyle get label => GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorsApp.instance.secondary,
      );

}

