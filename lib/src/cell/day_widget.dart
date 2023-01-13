import 'package:flutter/material.dart';
import 'package:month_calendar/src/theme.dart';
import 'package:system/system.dart';

import '../model/month_grid_builder.dart';

class Date extends StatelessWidget {
  final Day cell;

  const Date({super.key, required this.cell});

  bool isCurrentDay(DateTime date) => date.isSameDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      //padding: const EdgeInsets.only(top: 5, right: 5),
      child: Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        decoration: isCurrentDay(cell.date) && cell.isInMonth
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).extension<MontCalendarTheme>()?.currentDayColor ?? const Color.fromARGB(255, 255, 181, 185))
            : null,
        child: Text(
          cell.date.day.toString(),
          style: cell.isInMonth == false
              ? TextStyle(color: Colors.grey.shade400, fontSize: 14)
              : cell.isWeekend || cell.isHoliday!
              ? const TextStyle( color: Colors.red, fontSize: 18)
              : const TextStyle( color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}