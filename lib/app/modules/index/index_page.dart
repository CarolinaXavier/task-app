import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';

class IndexPage extends StatefulWidget {
  final String title;
  const IndexPage({super.key, this.title = 'IndexPage'});
  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {

  var currentIndex = 0;

  @override
  void initState() {
    Modular.to.navigate('/index-module/home-module/');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          switch (index) {
            case 0:
              Modular.to.navigate('/index-module/home-module/');
              break;
              case 1:
              Modular.to.navigate('/index-module/add-tasks-module/');
              break;
              case 2:
              Modular.to.navigate('/index-module/calendar-module/');
              break;
            default: Modular.to.navigate('/login');
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            unselectedColor: context.colors.tertiary,
            selectedColor: const Color.fromRGBO(134, 135, 231, 1),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.add),
            title: const Text("Adicionar"),
            unselectedColor: context.colors.tertiary,
            selectedColor: const Color.fromRGBO(134, 135, 231, 1),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            title: const Text("Calendário"),
            unselectedColor: context.colors.tertiary,
            selectedColor: const Color.fromRGBO(134, 135, 231, 1),
          ),
        ],
      ),
    );
  }
}
