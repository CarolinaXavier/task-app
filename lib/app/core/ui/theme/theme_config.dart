import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';

class ThemeConfig {
  ThemeConfig._();

  static const inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Color.fromRGBO(151, 151, 151, 1),
    ),
  );

  static final theme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsApp.instance.primary,
      primary: ColorsApp.instance.primary,
      secondary: ColorsApp.instance.secondary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color.fromRGBO(29, 29, 29, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color.fromRGBO(151, 151, 151, 1),
        ),
      ),
      enabledBorder: inputBorder,
      disabledBorder: inputBorder,
      focusedBorder: inputBorder,
      focusedErrorBorder: inputBorder,
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 50,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        color: Colors.white.withOpacity(0.87),
      ),
    ),
  );
}
