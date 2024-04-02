import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:task_app/app/repositories/login/login_repository.dart';

class LoginController extends Store<LoginState> {
  final repository = Modular.get<LoginRepository>();
  LoginController() : super(LoginSuccess(''));

  Future login(String email, String password) async {
    setLoading(true);
    try {
      final result = await repository.login(email, password);
    } catch (e) {
      setError(LoginError(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class LoginState {}

class LoginSuccess implements LoginState {
  dynamic result;
  LoginSuccess(this.result);
}

class LoginLoading implements LoginState {
  const LoginLoading();
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
