import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/add_tasks/controllers/edit_task_controller.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/modules/calendar/calendar_store.dart';
import 'package:task_app/app/modules/calendar/components/calendar_component.dart';
import 'package:task_app/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:task_app/app/modules/home/home_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final calendarController = Modular.get<CalendarController>();
  final editTaskController = Modular.get<EditTaskController>();
  final store = Modular.get<CalendarStore>();

  bool isHoje = true;
  bool isConcluido = false;

  @override
  void initState() {
    store.getTasks(calendarController.getDateString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendário',
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CalendarComponent(
            initialDate: calendarController.datetime,
            onPressed: (date) {
              calendarController.datetime = date;
              calendarController.getTaskByDate(date);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ScopedBuilder(
              store: store,
              onError: (context, error) {
                return Center(
                  child: Text(
                    'Houve um erro',
                    style: TextStyles.instance.titulo,
                  ),
                );
              },
              onLoading: (context) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 40,
                  ),
                );
              },
              onState: (context, CalendarSuccess state) {
                insertDateToday(state.result);
                insertTasksCompleted(state.result);
                return Visibility(
                  visible: state.result.isNotEmpty,
                  replacement: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/checklist.png'),
                        Text('O que você quer fazer hoje?',
                            style: TextStyles.instance.titulo),
                        Text('Toque em + para adicionar suas tarefas',
                            style: TextStyles.instance.label)
                      ],
                    ),
                  ),
                  child: ListenableBuilder(
                    listenable: editTaskController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(76, 76, 76, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ToogleButtonComponent(
                                    text: 'Hoje',
                                    backgroundColor: isHoje
                                        ? context.colors.primary
                                        : const Color.fromRGBO(76, 76, 76, 1),
                                    onPressed: () {
                                      setState(() {
                                        isHoje = true;
                                        isConcluido = false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: ToogleButtonComponent(
                                    text: 'Concluído',
                                    backgroundColor: isConcluido
                                        ? context.colors.primary
                                        : const Color.fromRGBO(76, 76, 76, 1),
                                    onPressed: () {
                                      setState(() {
                                        isConcluido = true;
                                        isHoje = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isHoje,
                            child: ListView.builder(
                              itemCount: calendarController.todaytasks.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                TaskModel task = calendarController.todaytasks[index];
                                return TaskComponent(
                                  task: task,
                                  value: task.completed!,
                                  onPressed: (value) {
                                    task.completed = value == true ? 1 : 0;
                                    calendarController
                                        .changeCompletedStatus(task);
                                  },
                                  onPressedEdit: (context) {
                                    Modular.to.pushNamed(
                                      './add-task-module/edit-task-page',
                                      arguments: task,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: isConcluido,
                            child: ListView.builder(
                              itemCount:
                                  calendarController.tasksCompleted.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                TaskModel task =
                                    calendarController.tasksCompleted[index];
                                return TaskComponent(
                                  task: task,
                                  value: task.completed!,
                                  onPressed: (value) {
                                    task.completed = value == true ? 1 : 0;
                                    calendarController
                                        .changeCompletedStatus(task);
                                  },
                                  onPressedEdit: (context) {
                                    Modular.to.pushNamed(
                                      './add-task-module/edit-task-page',
                                      arguments: task,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  insertDateToday(List<TaskModel> tasks) {
    calendarController.todaytasks.clear();
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    for (var task in tasks) {
      DateTime dateParse = DateTime.parse(task.time);
      DateTime date = DateTime(
        dateParse.year,
        dateParse.month,
        dateParse.day,
        calendarController.datetime.hour,
        calendarController.datetime.minute,
        calendarController.datetime.second,
      );
      if (date == DateTime.parse(format.format(calendarController.datetime)) &&
          task.completed != 1) {
        calendarController.todaytasks.add(task);
      }
    }
  }

  insertTasksCompleted(List<TaskModel> tasks) {
    calendarController.tasksCompleted.clear();
    for (var task in tasks) {
      if (task.completed == 1) {
        calendarController.tasksCompleted.add(task);
      }
    }
  }
}

class ToogleButtonComponent extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function()? onPressed;
  const ToogleButtonComponent(
      {required this.text,
      required this.onPressed,
      required this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              side: BorderSide(
                color: Color.fromRGBO(151, 151, 151, 1),
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyles.instance.label),
      ),
    );
  }
}
