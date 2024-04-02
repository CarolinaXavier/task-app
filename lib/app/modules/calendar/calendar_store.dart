import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/repositories/calendar/calendar_repository.dart';

class CalendarStore extends Store<CalendarSuccess>{
  final repository = Modular.get<CalendarRepository>();

  CalendarStore() : super(CalendarSuccess([]));

 Future getTasks(String dateTime) async {
  print('Store date: $dateTime');
  setLoading(true);
  try {
    final tasks = await repository.getTasks(dateTime);
    update(CalendarSuccess(tasks));
  } catch (e) {
    setError(CalendarError(e.toString()));
  } finally {
    setLoading(false);
  }
 }
}


abstract class CalendarState {}

class CalendarSuccess implements CalendarState {
  List<TaskModel> result;

  CalendarSuccess(this.result);
}

class CalendarLoading implements CalendarState {
  const CalendarLoading();
}

class CalendarError extends CalendarState {
  final String message;
  CalendarError(this.message);
}