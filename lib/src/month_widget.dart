
import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';
import 'model/month_calendar_header.dart';
import 'model/month_calendar_model_mixin.dart';
import 'model/month_grid_builder.dart';
import 'month_widget_builder.dart';
import 'theme.dart';

class MonthGrid extends StatefulWidget implements MouseEvent {
  final MonthCalendarHeaderBody? _header;
  final TableBorder? _border;
  @override
  final HoverEffect? hover;
  @override
  final TapEffect? tap;
  final void Function(DateTime?)? _selectDateCallback;
  final DateTime? selectedDate;
  final MonthGridBuilder _calendarGridBuilder;
  final Iterable<Dated>? children;

  MonthGrid(
      { super.key,
        required int year,
        required int month,
        this.selectedDate,
        HoverEffect? hoverDayEffect,
        TapEffect? tapDayEffect,
        void Function(DateTime?)? selectDateCallback,
        List<DateTime>? holidays,
        this.children,
        MonthCalendarHeaderBody? header,
        TableBorder? border})
      : _header = header,
        hover = hoverDayEffect,
        _selectDateCallback = selectDateCallback,
        tap = tapDayEffect,
        _border = border,
        _calendarGridBuilder = MonthGridBuilder(year, month, holidays: holidays);
  @override
  State<MonthGrid> createState() => _MonthGridState();
}

class _MonthGridState extends State<MonthGrid> {

  var widgetHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, monthConstraints) {
      widgetHeight = monthConstraints.maxHeight;
      return Theme(
        data: Theme.of(context).copyWith(
          extensions: [MontCalendarTheme.light],
          colorScheme: Theme.of(context).colorScheme.copyWith(
            surface: Colors.brown
          )
        ),
        child: MonthBody(
          height: widgetHeight,
          selectedDate: widget.selectedDate,
          calendarGridBuilder: widget._calendarGridBuilder,
          hoverDayEffect: widget.hover,
          tapDayEffect: widget.tap,
          selectDateCallback: widget._selectDateCallback,
          children: widget.children,
          header: widget._header,
          border: widget._border,
        ),
      );
    });
  }
}
