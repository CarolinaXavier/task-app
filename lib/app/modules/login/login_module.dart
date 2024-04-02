import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/modules/login/controllers/login_controller.dart';
import 'package:task_app/app/modules/login/controllers/register_controller.dart';
import 'package:task_app/app/modules/login/pages/login_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/modules/login/pages/register_page.dart';
import 'package:task_app/app/repositories/login/login_repository.dart';
import 'package:task_app/app/repositories/login/login_repository_impl.dart';

class LoginModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(CustomDio.new);
    i.addLazySingleton(LoginController.new);
    i.addLazySingleton(RegisterController.new);
    i.addLazySingleton<LoginRepository>(LoginRepositoryImpl.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const LoginPage());
    r.child('/register-page', child: (context) => const RegisterPage());
    super.routes(r);
  }
}
