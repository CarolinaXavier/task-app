import 'package:dio/dio.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/core/rest_client/dio_interceptor.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';

class AddTaskRepositoryImpl implements AddTaskRepository {
  final CustomDio _dio;
  AddTaskRepositoryImpl(this._dio) {
    _dio.interceptors.add(DioInterceptor());
  }

  @override
  Future createTask(TaskModel task) async {
    try {
      await _dio.post(
        'tasks/add',
        data: {
          "name": task.name,
          "description": task.description,
          "time": task.time,
        },
      ).then((value) {
        print('POST INSERT TAREFA: ${value.data}');
      });
    } on DioException catch (e) {
      print(
          '<!---Erro ao criar task---!> erro: ${e.response} | message: ${e.message}');
    }
  }

  @override
  deleteTask(String taskId) async {
    try {
      await _dio.delete('tasks/delete/$taskId').then((value) {
        print('DELETE EXCLUIR TAREFA: ${value.data}');
      });
    } on DioException catch (e) {
      print(
          '<!---Erro ao criar task---!> erro: ${e.response} | message: ${e.message}');
    }
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

  @override
  Future editTask(TaskModel task) async {
    try {
      await _dio.patch(
        'tasks/edit/${task.id}',
        data: {
          "name": task.name,
          "description": task.description,
          "time": task.time,
          "completed": task.completed,
        },
      ).then((value) {
         print('EDITAR TAREFA: ${value.data}');
      });
    } on DioException catch (e) {
      print('<!---Erro ao editar task---!> erro: ${e.response} | message: ${e.message}');
    }
  }
}
