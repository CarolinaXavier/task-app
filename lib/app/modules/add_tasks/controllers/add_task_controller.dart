import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';

class AddTaskController extends ChangeNotifier {
  final repository = Modular.get<AddTaskRepository>();

  void createTask(String name, String description, String time) async {
    final task = TaskModel(
      name: name,
      description: description,
      time: time,
    );
    await repository.createTask(task).then((value) => Modular.to.navigate('/index-module/home-module/'));
  }
}
