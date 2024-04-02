import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/store/storage.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/modules/home/store/home_store.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';
import 'package:task_app/app/repositories/home/home_repository.dart';

class HomeController extends ChangeNotifier {
  Timer? _debounce;
  List<TaskModel> tasksNotCompleted = [];
  List<TaskModel> tasksCompleted = [];
  List<TaskModel> researchedTasks = [];

  final repository = Modular.get<AddTaskRepository>();
  final homeRepository = Modular.get<HomeRepository>();
  final store = Modular.get<HomeStore>();

  List<TaskModel> searchTasks(String value, List<TaskModel> tasks) {
    var text = value.trim().toUpperCase();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (text.isNotEmpty) {
        researchedTasks = tasks.where((task) {
         String tarefa = task.name.toUpperCase();
         return tarefa.contains(text);
        }).toList();
      } else {
        researchedTasks.clear();
        notifyListeners();
      }
    });
    notifyListeners();
    return researchedTasks;
  }

  Future<void> logout() async {
    //Modular.to.navigate('/login/');
    homeRepository.logout().then((value) => Modular.to.navigate('/login/'));
  }

  changeCompletedStatus(TaskModel task) {
    print('Task: ${task.name} | ${task.completed}');
    repository.changeCompletedStatus(task).then((value) => store.getTasks());
  }
}
