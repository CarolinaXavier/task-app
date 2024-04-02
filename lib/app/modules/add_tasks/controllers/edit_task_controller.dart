import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/modules/home/store/home_store.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';

class EditTaskController extends ChangeNotifier {
  final repository = Modular.get<AddTaskRepository>();
  final homeStore = Modular.get<HomeStore>();

  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();


  editTask(TaskModel task, DateTime date, TimeOfDay time) async {
    date = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    String dateTimeParse = format.format(date);
    await repository.editTask(
      TaskModel(
        id: task.id,
        name: taskTitleController.text,
        description: taskDescriptionController.text,
        time: dateTimeParse,
        completed: task.completed,
      ),
    ).whenComplete(() {
      Modular.to.navigate('/index-module/home-module/');
      homeStore.getTasks();
      notifyListeners();
    });
  }

  deleteTask(String taskId) async {
    await repository.deleteTask(taskId);
    notifyListeners();
    Modular.to.pop();
  }
}
