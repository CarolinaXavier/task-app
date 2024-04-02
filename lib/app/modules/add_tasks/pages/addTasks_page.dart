import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/add_tasks/controllers/add_task_controller.dart';
import 'package:validatorless/validatorless.dart';

class AddTasksPage extends StatefulWidget {
  const AddTasksPage({super.key});
  @override
  AddTasksPageState createState() => AddTasksPageState();
}

class AddTasksPageState extends State<AddTasksPage> {
  bool isAddTask = true;
  bool isAddDescription = false;
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<AddTaskController>();

  final nameTaskController = TextEditingController();
  final descriptionTaskTaskController = TextEditingController();
  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  void dispose() {
    nameTaskController.dispose();
    descriptionTaskTaskController.dispose();
    super.dispose();
  }

  TextStyle get styleText => GoogleFonts.lato(fontSize: 18, color: Colors.white.withOpacity(0.87));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 32, right: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameTaskController,
                onTap: () {
                  setState(() {
                    isAddTask = true;
                    isAddDescription = false;
                  });
                },
                style: styleText,
                decoration: InputDecoration(
                  hintText: 'Nome da tarefa',
                  hintStyle: TextStyles.instance.label.copyWith(
                    color: context.colors.tertiary,
                  ),
                  enabledBorder: isAddTask ? null : InputBorder.none,
                  filled: false,
                ),
                validator: Validatorless.required('Nome da tarefa Obrigatório'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionTaskTaskController,
                onTap: () {
                  setState(() {
                    isAddDescription = true;
                    isAddTask = false;
                  });
                },
                style: styleText,
                decoration: InputDecoration(
                  hintText: 'Descrição',
                  hintStyle: TextStyles.instance.label.copyWith(
                    color: context.colors.tertiary,
                  ),
                  enabledBorder: isAddDescription ? null : InputBorder.none,
                  filled: false,
                ),
                validator:
                    Validatorless.required('Descrição da tarefa Obrigatório'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: selectDate,
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: context.colors.secondary,
                        ),
                      ),
                      IconButton(
                        onPressed: selectHour,
                        icon: Icon(
                          Icons.timer_outlined,
                          color: context.colors.secondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      final isValid = _formKey.currentState?.validate() ?? false;
                      if (isValid) {
                        String name = nameTaskController.text;
                        String description = descriptionTaskTaskController.text;
                        dateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          time.hour,
                          time.minute,
                        );
                        final format = DateFormat('yyyy-MM-ddTHH:mm:ssZ', 'en-US');
                        String dateTimeParse = format.format(dateTime);
                        controller.createTask(name, description, dateTimeParse);
                      }
                    },
                    icon: Icon(
                      Icons.send_outlined,
                      color: context.colors.primary,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectHour() async {
    final TimeOfDay? hour = await showTimePicker(
      //initialEntryMode: TimePickerEntryMode.input,
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
      print('HOUR: $hour');
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
      print('Date: ${DateTime.parse(format.format(date))}');
      dateTime = DateTime.parse(format.format(date));
    }
  }
}
