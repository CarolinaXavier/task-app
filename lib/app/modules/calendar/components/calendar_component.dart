import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';

class CalendarComponent extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime date)? onPressed;
  const CalendarComponent({required this.initialDate, required this.onPressed});

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  
  DateTime? _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      activeColor: context.colors.primary,
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
        monthStyle: TextStyle(color: Colors.white),
        selectedDateStyle: TextStyle(color: Colors.white),
      ),
      initialDate: widget.initialDate,
      dayProps: EasyDayProps(
        todayStyle: const DayStyle(
          dayNumStyle: TextStyle(color: Colors.white),
        ),
        height: 80,
        width: 50,
        inactiveDayStyle: DayStyle(
          dayNumStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(39, 39, 39, 1),
          ),
        ),
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(color: context.colors.primary),
        ),
      ),
      timeLineProps: const EasyTimeLineProps(
        separatorPadding: 12,
      ),
      locale: 'pt_br',
      // controller: _controller,
      // firstDate: DateTime(2023),
      // focusDate: _focusDate,
      // lastDate: DateTime(2023, 12, 31),
      onDateChange: widget.onPressed,
    );
  }
}
