
import 'package:system/system.dart';

class MonthGridBuilder {
  final DateTime _date;
  List<GridCell> _dates = [];
  List<DateTime>? _holidays;

  MonthGridBuilder(int year, int month, {List<DateTime>? holidays})
      : _date = DateTime(year, month, 1) {
    _holidays = holidays;
    _dates = _generate();
  }

  List<GridCell> _generate() {
    var startCalendarDay = _date.add(Duration(days: -(_date.weekday - 1)));

    var daysBeforeMonth = _date.weekday - 1;
    for (var i = 0; i < daysBeforeMonth; i++) {
      var previousMonthDate = startCalendarDay.add(Duration(days: i));
      var cell = GridCell(
          date: DateTime.fromMillisecondsSinceEpoch(previousMonthDate.millisecondsSinceEpoch),
          isInMonth: false,
          isWeekend: previousMonthDate.weekday == 6 || previousMonthDate.weekday == 7);
      _dates.add(cell);
    }

    var monthDayCount = DateTime(_date.year, _date.month + 1, 0).day;
    for (var i = 0; i < monthDayCount; i++) {
      var currentMonthDate =
          DateTime(_date.year, _date.month, _date.day + i, _date.hour, _date.minute);
      var isWeekEnd = currentMonthDate.weekday == 6 || currentMonthDate.weekday == 7;

      bool isHoliday = false;
      if (_holidays != null) {
        for (var i = 0; i < _holidays!.length; i++) {
          var dt = _holidays![i];
          if (dt.isSameDate(currentMonthDate)) {
            isHoliday = true;
          }
        }
      }

      //var inHolidays = _holidays.any((element) => element.isSameDate(currentMonthDate));
      if (isHoliday) isWeekEnd = true;

      var cell = GridCell(
          date: DateTime.fromMillisecondsSinceEpoch(currentMonthDate.millisecondsSinceEpoch),
          isInMonth: true,
          isWeekend: isWeekEnd);

      _dates.add(cell);
    }

    var lastDate = DateTime(
        _date.year, _date.month, _date.day + (monthDayCount - 1), _date.hour, _date.minute);

    var daysToEnd = 6 * 7 - (daysBeforeMonth + monthDayCount);
    for (var i = 1; i <= daysToEnd; i++) {
      var nextMonthDate =
          DateTime(lastDate.year, lastDate.month, lastDate.day + i, lastDate.hour, lastDate.minute);
      var cell = GridCell(
          date: DateTime.fromMillisecondsSinceEpoch(nextMonthDate.millisecondsSinceEpoch),
          isInMonth: false,
          isWeekend: nextMonthDate.weekday == 6 || nextMonthDate.weekday == 7);

      _dates.add(cell);
    }

    return _dates;
  }

  List<GridCell> getDates() => _dates;
}

class GridCell {
  final bool isInMonth;
  final bool? isWeekend;
  //final bool? isHoliday;
  final DateTime date;

  const GridCell({
    required this.date,
    required this.isInMonth,
    this.isWeekend,
    //this.isHoliday
  });
}
