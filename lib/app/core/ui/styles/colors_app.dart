import 'package:flutter/material.dart';

class ColorsApp {

  static ColorsApp? _instance;
  ColorsApp._();
  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color.fromRGBO(134, 135, 231, 1);
  Color get secondary => const Color.fromRGBO(255, 255, 255, 0.87);
  Color get tertiary => const Color.fromRGBO(175, 175, 175, 1);
}

extension ColorsAppExceptions on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}