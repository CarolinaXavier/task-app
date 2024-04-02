import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/repositories/home/home_repository.dart';

class HomeStore extends Store<HomeSuccess> {
  final repository = Modular.get<HomeRepository>();
  final dateTime = DateTime.now();
  HomeStore() : super(HomeSuccess([]));

  Future getTasks() async {
    print('HomeStore');
    setLoading(true);
    try {
      final tasks = await repository.getTasks(dateTime.toString().substring(0, 10));
      update(HomeSuccess(tasks));
    } catch (e) {
      setError(HomeError(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}

abstract class HomeState {}

class HomeSuccess implements HomeState {
  List<TaskModel> result;

  HomeSuccess(this.result);
}

class HomeLoading implements HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
