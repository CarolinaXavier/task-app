import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/env/env.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  await Env.instance.load();
 runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}