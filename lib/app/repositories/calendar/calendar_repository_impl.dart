import 'package:dio/dio.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/core/rest_client/dio_interceptor.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/repositories/calendar/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CustomDio _dio;

  CalendarRepositoryImpl(this._dio) {
    _dio.interceptors.add(DioInterceptor());
  }

  @override
  Future<List<TaskModel>> getTasks(String date) async {
    try {
      final tasks = await _dio.get('tasks/list/$date');
      return tasks.data['data'].map<TaskModel>((p) => TaskModel.fromMap(p)).toList();
    } on DioException catch (e) {
      print('<!---Erro ao buscar lista de tarefas---!> erro: $e');
    }
    throw UnimplementedError();
  }
  
  @override
  Future changeCompletedStatus(TaskModel task) async {
   bool completed;

    if (task.completed == 1) {
      completed = true;
    } else {
      completed = false;
    }

    try {
      await _dio.patch(
        'tasks/edit/${task.id}',
        data: {
          "completed": completed,
        },
      ).then((value) {
        print('CHANGE TAREFA: ${value.data}');
      });
    } on DioException catch (e) {
      print(
          '<!---Erro ao alterar task---!> erro: ${e.response} | message: ${e.message}');
    }
  }
}
