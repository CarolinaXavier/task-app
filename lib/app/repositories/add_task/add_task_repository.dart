
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';

abstract class AddTaskRepository {
  Future createTask(TaskModel task);
  Future editTask(TaskModel task);
  Future changeCompletedStatus(TaskModel task);
  deleteTask(String taskId);
}