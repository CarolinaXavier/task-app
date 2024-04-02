import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_app/app/core/components/elevated_button_component.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/add_tasks/controllers/edit_task_controller.dart';
import 'package:task_app/app/modules/add_tasks/models/task_model.dart';

class EditTasksPage extends StatefulWidget {
  final TaskModel task;
  const EditTasksPage({super.key, required this.task});

  @override
  State<EditTasksPage> createState() => _EditTasksPageState();
}

class _EditTasksPageState extends State<EditTasksPage> {
  final controller = Modular.get<EditTaskController>();

  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  String date = '';
  String hour = '';

  bool isAddTask = true;
  bool isAddDescription = false;

  @override
  void initState() {
    print('Task: ${widget.task}');
    if (widget.task.name.isNotEmpty) {
      controller.taskTitleController.text = widget.task.name;
      controller.taskDescriptionController.text = widget.task.description;
      final dateParse = DateTime.parse(widget.task.time);
      dateTime = dateParse;
      date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      hour = '${dateTime.hour}:${dateTime.minute}';
      time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   controller.taskTitleController.dispose();
  //   controller.taskDescriptionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar tarefa'),
        leading: InkWell(
          onTap: () => Modular.to.navigate('/index-module/home-module/'),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(29, 29, 29, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Icon(Icons.close_rounded, color: context.colors.secondary),
          ),
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 32, right: 16),
        child: Column(
          children: [
            TextFormField(
              controller: controller.taskTitleController,
              decoration: InputDecoration(
                hintText: 'Nome da tarefa',
                hintStyle: TextStyles.instance.label.copyWith(
                  color: context.colors.tertiary,
                ),
                filled: false,
                enabledBorder: isAddTask ? null : InputBorder.none,
              ),
              style: TextStyles.instance.label.copyWith(fontSize: 20),
              onTap: () {
                setState(() {
                  isAddTask = true;
                  isAddDescription = false;
                });
              },
            ),
            TextFormField(
              controller: controller.taskDescriptionController,
              decoration: InputDecoration(
                hintText: 'Descrição',
                hintStyle: TextStyles.instance.label.copyWith(
                  color: context.colors.tertiary,
                ),
                filled: false,
                enabledBorder: isAddDescription ? null : InputBorder.none,
              ),
              style: TextStyles.instance.label,
              onTap: () {
                setState(() {
                  isAddDescription = true;
                  isAddTask = false;
                });
              },
            ),
            const SizedBox(height: 24),
            RowIconComponent(
              title: 'Hora da tarefa',
              icone: Icons.timer_outlined,
              value: 'Hoje às $hour',
              onTap: selectHour,
            ),
            const SizedBox(height: 24),
            RowIconComponent(
              title: 'Data da tarefa',
              icone: Icons.calendar_month_outlined,
              value: date,
              onTap: selectDate,
            ),
            const SizedBox(height: 32),
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              onTap: () => showConfirmDialog(),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      color: Color.fromRGBO(255, 73, 73, 1),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Excluir tarefa',
                      style: TextStyles.instance.label.copyWith(
                        color: const Color.fromRGBO(255, 73, 73, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: ElevatedButtonComponent(
          labelText: 'Editar Tarefa',
          onPressed: () {
            controller.editTask(widget.task, dateTime, time);
          },
        ),
      ),
    );
  }

  Future<void> selectHour() async {
    final TimeOfDay? hour = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme:
                TextTheme(bodyMedium: GoogleFonts.lato(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              brightness: Brightness.dark,
              cardColor: const Color.fromRGBO(54, 54, 54, 1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (hour != null) {
      time = hour;
      this.hour = '${time.hour}:${time.minute}';
      setState(() {});
    }
  }

  Future<void> selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme:
                TextTheme(bodyMedium: GoogleFonts.lato(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              brightness: Brightness.dark,
              cardColor: const Color.fromRGBO(54, 54, 54, 1),
            ),
          ),
          child: child!,
        );
      },
    );
    final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
    if (date != null) {
      dateTime = DateTime.parse(format.format(date));
      this.date = '${date.day}/${date.month}/${dateTime.year}';
      setState(() {});
    }
  }

  Future<bool?> showConfirmDialog() {
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
                Modular.to.pop();
                controller.deleteTask(widget.task.id!);
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

class RowIconComponent extends StatelessWidget {
  final String title;
  final IconData icone;
  final String value;
  final Function()? onTap;
  const RowIconComponent(
      {required this.title,
      required this.icone,
      required this.value,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: false,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icone,
                  color: context.colors.secondary,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyles.instance.label,
                ),
              ],
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.colors.secondary.withOpacity(0.21),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: Text(
                value,
                style: TextStyles.instance.label.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
