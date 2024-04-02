import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/core/rest_client/custom_dio.dart';
import 'package:task_app/app/modules/add_tasks/addTasks_module.dart';
import 'package:task_app/app/modules/add_tasks/controllers/edit_task_controller.dart';
import 'package:task_app/app/modules/home/controllers/home_controller.dart';
import 'package:task_app/app/modules/home/store/home_store.dart';
import 'package:task_app/app/modules/login/login_module.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository.dart';
import 'package:task_app/app/repositories/add_task/add_task_repository_impl.dart';
import 'package:task_app/app/repositories/home/home_repository.dart';
import 'package:task_app/app/repositories/home/home_repository_impl.dart';

import 'home_page.dart';
 
class HomeModule extends Module {

  @override
  void binds(Injector i) {
    i.addLazySingleton(CustomDio.new);
    i.addLazySingleton<HomeRepository>(HomeRepositoryImpl.new);
    i.addLazySingleton<AddTaskRepository>(AddTaskRepositoryImpl.new);
    i.addLazySingleton(HomeStore.new);
    i.addLazySingleton(HomeController.new);
    i.addLazySingleton(EditTaskController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
    r.module('/add-task-module', module: AddTasksModule());
    r.module('/login-module', module: LoginModule());
    super.routes(r);
  }

}