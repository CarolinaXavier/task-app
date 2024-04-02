
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';

abstract class CalendarRepository {
  Future<List<TaskModel>> getTasks(String date);
  Future changeCompletedStatus(TaskModel task);
}