import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/modules/add_tasks/controllers/add_task_controller.dart';
import 'package:task_app/app/modules/add_tasks/controllers/edit_task_controller.dart';
import 'package:task_app/app/modules/add_tasks/pages/addTasks_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/modules/add_tasks/pages/edit_tasks_page.dart';
import 'package:task_app/app/modules/home/store/home_store.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository_impl.dart';

class AddTasksModule extends Module {

  @override
  void binds(Injector i) {
    i.addLazySingleton(CustomDio.new);
    i.addLazySingleton<AddTaskRepository>(AddTaskRepositoryImpl.new);
    i.addLazySingleton(HomeStore.new);
    i.addLazySingleton(AddTaskController.new);
    i.addLazySingleton(EditTaskController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const AddTasksPage());
    r.child('/edit-task-page', child: (context) => EditTasksPage(task: r.args.data));
    super.routes(r);
  }
}
