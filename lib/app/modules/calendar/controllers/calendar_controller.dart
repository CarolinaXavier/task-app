
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/modules/calendar/calendar_store.dart';
import 'package:task_app/app/repositories/calendar/calendar_repository.dart';

class CalendarController extends ChangeNotifier {

  final repository = Modular.get<CalendarRepository>();
  final store = Modular.get<CalendarStore>();

  DateTime datetime = DateTime.now();

  List<TaskModel> todaytasks = [];
  List<TaskModel> tasksCompleted = [];

  String get getDateString => datetime.toString().substring(0, 10);

  getTaskByDate(DateTime date) {
    print('Date substring: $getDateString');
    store.getTasks(getDateString);
  }

  changeCompletedStatus(TaskModel task) {
    repository.changeCompletedStatus(task).then((value) => store.getTasks(getDateString));
  }
}