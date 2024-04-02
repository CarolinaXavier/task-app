
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/store/storage.dart';

class DioInterceptor extends Interceptor {
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await Storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  onError(DioException e, ErrorInterceptorHandler handler) {
    print('Passou por aqui onError $e');
    if (e.response?.statusCode == 401) {
      Modular.to.navigate('/login');
      Storage.clear();
      return handler.next(e);
    }
    return handler.next(e);
  }
}