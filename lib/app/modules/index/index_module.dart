import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_app/app/modules/add_tasks/addTasks_module.dart';
import 'package:task_app/app/modules/calendar/calendar_module.dart';
import 'package:task_app/app/modules/home/home_module.dart';
import 'package:task_app/app/modules/index/index_page.dart';
import 'package:task_app/app/modules/login/login_module.dart';

class IndexModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const IndexPage(), children: [
      ModuleRoute('/home-module', module: HomeModule()),
      ModuleRoute('/add-tasks-module', module: AddTasksModule()),
      ModuleRoute('/calendar-module', module: CalendarModule()),
    ]);
    r.module('/login-module', module: LoginModule());
    super.routes(r);  	
  }
}
