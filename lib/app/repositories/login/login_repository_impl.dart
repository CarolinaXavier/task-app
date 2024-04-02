import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/repositories/login/login_repository.dart';

import '../../core/store/storage.dart';

class LoginRepositoryImpl implements LoginRepository {
  final CustomDio _dio;

  LoginRepositoryImpl(this._dio) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
    ));
  }
  @override
  Future login(String email, String senha) async {
    try {
      final result = await _dio.post('user/login', data: {
        'email': email,
        'password': senha,
      });
      await _saveToken(result.data);
      Modular.to.pushNamed('/index-module/');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Storage.clear();
      }
      throw UnimplementedError(e.response?.statusCode.toString());
    }
  }

  @override
  Future register(String userName, String email, String senha) async {
    try {
      await _dio.post(
        'user/register',
        data: {
          "name": userName,
          "email": email,
          "password": senha,
        },
      ).then((value) {
         print('REGISTER USER: ${value.data}');
      });
    } on DioException catch (e) {
      throw UnimplementedError(e.response?.statusCode.toString());
    }
  }

  Future<void> _saveToken(Map data) async {
    final token = data['data']['access_token'];
    await Storage.setToken(token);
  }
}
