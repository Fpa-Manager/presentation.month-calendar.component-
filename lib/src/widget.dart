import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';
import 'model/month_calendar_header.dart';
import 'model/month_calendar_model_mixin.dart';
import 'month_widget_builder.dart';
import 'theme.dart';
import 'package:system/system.dart';

class DummMonthCalendar extends StatelessWidget {
  final MonthCalendarHeader? _header;
  final TableBorder? _border;
  final List<Day> _monthDays;
  final Iterable<CellContent>? children;

  final SelectedEffect? select;
  final HoverEffect? hover;
  final TapEffect? tap;

  DummMonthCalendar(
      {super.key,
        required int year,
        required int month,
        List<DateTime>? holidays,
        this.children,
        this.select,
        this.hover,
        this.tap,
        MonthCalendarHeader? header,
        TableBorder? border})
      : _header = header,
        _border = border,
        _monthDays = Calendar(holidays: holidays).getMonth(year, month, MonthVariant.calendarGrid);

  @override
  Widget build(BuildContext context) {
    var widgetHeight = 0.0;
    var widgetWidth = 0.0;

    return LayoutBuilder(builder: (context, monthConstraints) {
      widgetHeight = monthConstraints.maxHeight;
      widgetWidth = monthConstraints.maxWidth;
      return Theme(
        data: Theme.of(context).copyWith(
            extensions: [MontCalendarTheme.light],
            colorScheme: Theme.of(context).colorScheme.copyWith(surface: Colors.brown)),
        child: DummCalendarBuilder(
          height: widgetHeight,
          width: widgetWidth,
          monthDays: _monthDays,
          children: children,
          header: _header,
          border: _border,
          select: select,
          hover: hover,
          tap: tap,
        ),
      );
    });
  }
}

class SelectedEffect {
  final bool? isSelectable;
  final BoxDecoration? decoration;
  final DateTime? selectedDate;
  final void Function(DateTime?)? selectDateCallback;

  SelectedEffect({this.isSelectable, this.decoration, this.selectedDate, this.selectDateCallback});
}
