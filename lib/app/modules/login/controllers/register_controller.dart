import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:task_app/app/repositories/login/login_repository.dart';

class RegisterController extends Store<RegisterState> {
  final repository = Modular.get<LoginRepository>();
  RegisterController() : super(RegisterSuccess(''));

  Future register(String userName, String email, String senha) async {
    setLoading(true);
    try {
      final result = repository.register(userName, email, senha);
      update(RegisterSuccess(result));
      Modular.to.navigate('/login/');
    } catch (e) {
      setError(RegisterError(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}


abstract class RegisterState {}

class RegisterSuccess implements RegisterState {
  dynamic result;
  RegisterSuccess(this.result);
}

class RegisterLoading implements RegisterState {
  const RegisterLoading();
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}
