import 'package:dio/dio.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/core/rest_client/dio_interceptor.dart';
import 'package:task_app/app/repositories/home/home_repository.dart';

import '../../core/store/storage.dart';
import '../../modules/add_tasks/models/task_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final CustomDio _dio;

  HomeRepositoryImpl(this._dio) {
    _dio.interceptors.add(DioInterceptor());
  }

  @override
  Future getTasks(String date) async {
    try {
      final tasks = await _dio.get('tasks/list/$date');
      return tasks.data['data']
          .map<TaskModel>((p) => TaskModel.fromMap(p))
          .toList();
    } on DioException catch (e) {
      print('<!---Erro ao buscar lista de tarefas---!> erro: $e');
    }
  }

  @override
  Future logout() async {
    final token = await Storage.getToken();
    try {
      _dio.get('user/logout', options: Options(headers: {
        "Authorization": 'Bearer $token',
        'Accept' : 'application/json',
      })).then((value) {
        
      });
      Storage.clear();
    } on DioException catch (e) {
      print('<!---Erro ao deslogar o usuário---!> erro: $e');
    }
  }
}
