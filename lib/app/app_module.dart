import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/modules/index/index_module.dart';
import 'package:task_app/app/modules/login/login_module.dart';

import 'core/store/storage.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(CustomDio.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.module(
      '/login',
      module: LoginModule(),
      guards: [AuthGuard()],
      transition: TransitionType.fadeIn,
    );
    r.module('/index-module', module: IndexModule(), transition: TransitionType.fadeIn);
    super.routes(r);
  }
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/index-module/');

  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    String? token = await Storage.getToken() ?? '';
    print('$token');
    if (token.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
