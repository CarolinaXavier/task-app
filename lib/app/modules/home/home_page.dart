import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/add_tasks/controllers/edit_task_controller.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';
import 'package:task_app/app/modules/home/components/box_tag_component.dart';
import 'package:task_app/app/modules/home/controllers/home_controller.dart';
import 'package:task_app/app/modules/home/store/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  final store = Modular.get<HomeStore>();

  final editTaskController = Modular.get<EditTaskController>();
  final homeController = Modular.get<HomeController>();

  final dateToday = DateTime.now();

  int? pesquisada = 0;
  int? hoje = 0;
  int? concluida = 0;

  @override
  void initState() {
    store.getTasks();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Início',
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: Colors.red),
            onPressed: () => homeController.logout(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: editTaskController,
        builder: (context, child) {
          searchController.clear();
          return ScopedBuilder(
            store: store,
            onLoading: (context) {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 40,
                ),
              );
            },
            onError: (context, error) {
              return Center(
                child: Text('Houve um erro', style: TextStyles.instance.titulo),
              );
            },
            onState: (context, HomeSuccess state) {
              List<TaskModel> tasks = state.result;
              insertDateToday(tasks);
              insertTasksCompleted(tasks);
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
                child: ListView(
                  padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 48,
                          child: TextFormField(
                            controller: searchController,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              homeController.searchTasks(value, state.result);
                            },
                            decoration: InputDecoration(
                              label: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    color: context.colors.tertiary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Procure sua tarefa...',
                                    style: TextStyles.instance.label,
                                  ),
                                ],
                              ),
                              labelStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: context.colors.tertiary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListenableBuilder(
                          listenable: homeController,
                          builder: (context, child) {
                            return Visibility(
                              visible:
                                  homeController.researchedTasks.isNotEmpty,
                              replacement: Column(
                                children: [
                                  Visibility(
                                    visible: homeController
                                        .tasksNotCompleted.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const BoxTagComponent(
                                            labelText: 'Hoje'),
                                        ListView.builder(
                                          itemCount: homeController
                                              .tasksNotCompleted.length,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            TaskModel task = homeController
                                                .tasksNotCompleted[index];
                                            return TaskComponent(
                                              task: task,
                                              value: task.completed!,
                                              onPressed: (value) {
                                                task.completed =
                                                    value == true ? 1 : 0;
                                                homeController
                                                    .changeCompletedStatus(
                                                        task);
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
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: homeController
                                        .tasksCompleted.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const BoxTagComponent(
                                          labelText: 'Concluído',
                                          width: 128,
                                        ),
                                        ListView.builder(
                                          itemCount: homeController
                                              .tasksCompleted.length,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            TaskModel task = homeController
                                                .tasksCompleted[index];
                                            return TaskComponent(
                                              task: task,
                                              value: task.completed!,
                                              onPressed: (value) {
                                                task.completed =
                                                    value == true ? 1 : 0;
                                                homeController
                                                    .changeCompletedStatus(
                                                        task);
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                itemCount:
                                    homeController.researchedTasks.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  TaskModel task =
                                      homeController.researchedTasks[index];
                                  return TaskComponent(
                                    task: task,
                                    onPressed: (value) {
                                      task.completed = value == true ? 1 : 0;
                                      homeController
                                          .changeCompletedStatus(task);
                                    },
                                    value: task.completed!,
                                    onPressedEdit: (context) {
                                      Modular.to.pushNamed(
                                        './add-task-module/edit-task-page',
                                        arguments: task,
                                      );
                                      searchController.clear();
                                      homeController.researchedTasks.clear();
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  insertDateToday(List<TaskModel> tasks) {
    homeController.tasksNotCompleted.clear();
    for (var task in tasks) {
      if (task.completed != 1) {
        homeController.tasksNotCompleted.add(task);
      }
    }
  }

  insertTasksCompleted(List<TaskModel> tasks) {
    homeController.tasksCompleted.clear();
    for (var task in tasks) {
      if (task.completed == 1) {
        homeController.tasksCompleted.add(task);
      }
    }
  }
}

class TaskComponent extends StatelessWidget {
  final TaskModel task;
  final int value;
  final Function(bool? value)? onPressed;
  final Function(BuildContext context)? onPressedEdit;
  TaskComponent({
    super.key,
    required this.task,
    required this.onPressedEdit,
    required this.onPressed,
    required this.value,
  });

  final controller = Modular.get<EditTaskController>();

  getHour(TaskModel task) {
    final date = DateTime.parse(task.time);
    final time = TimeOfDay(hour: date.hour, minute: date.minute);
    String hour = '${time.hour}: ${time.minute}';
    return hour;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: null,
        children: [
          SlidableAction(
            autoClose: false,
            onPressed: onPressedEdit,
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) {
              showConfirmDialog(task.id!, context);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        height: 85,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(54, 54, 54, 1),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value == 0 ? false : true,
              onChanged: onPressed,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: TextStyles.instance.label,
                ),
                const SizedBox(height: 8),
                Text(
                  'Hoje às ${getHour(task)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: context.colors.tertiary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> showConfirmDialog(String taskId, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
          title: Text(
            'Deseja excluir a tarefa?',
            style: TextStyles.instance.label,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Modular.to.pop(),
              child: const Text('Não'),
            ),
            OutlinedButton(
              onPressed: () {
                controller.deleteTask(taskId);
              },
              child: const Text(
                'Sim',
              ),
            ),
          ],
        );
      },
    );
  }
}
