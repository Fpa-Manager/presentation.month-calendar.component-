import 'package:flutter/material.dart';
import 'package:month_calendar/src/theme.dart';
import 'package:mytheme/theme.dart';
import 'package:system/system.dart' as system;
import 'package:system/system.dart';
import 'cell/cell_widget.dart';
import 'model/month_calendar_header.dart';
import 'model/month_calendar_model_mixin.dart';
import 'model/month_grid_builder.dart';

class MonthBody extends StatefulWidget implements MouseEvent {
  final MonthCalendarHeaderBody? _header;
  final TableBorder? _border;

  @override
  final HoverEffect? hover;
  @override
  final TapEffect? tap;

  final void Function(DateTime?)? _selectDateCallback;
  final DateTime? selectedDate;

  final MonthGridBuilder _calendarGridBuilder;

  final List<Day> _monthDays;

  final Iterable<CellContent>? children;

  final double height;
  final double width;

  MonthBody(
      { super.key,
        this.selectedDate,
        required this.height,
        required this.width,
        required List<Day> monthDays,
        required MonthGridBuilder calendarGridBuilder,
        HoverEffect? hoverDayEffect,
        TapEffect? tapDayEffect,
        void Function(DateTime?)? selectDateCallback,
        this.children,
        MonthCalendarHeaderBody? header,
        TableBorder? border})
      : _header = header,
        hover = hoverDayEffect,
        _selectDateCallback = selectDateCallback,
        tap = tapDayEffect,
        _border = border,
        _monthDays = monthDays,
        _calendarGridBuilder = calendarGridBuilder;

  @override
  State<MonthBody> createState() => _MonthBodyState();
}

class _MonthBodyState extends State<MonthBody> {
  DateTime? initSelectedDateValue;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    initSelectedDateValue = widget.selectedDate ?? DateTime(1900, 01, 01);
  }

  DateTime? selectedDayValue(DateTime date) =>
      selectedDate != null && selectedDate == date ? null : date;

  void selectDay(DateTime date) {
    setState(() {
      selectedDate = selectedDayValue(date);
    });
    if (widget._selectDateCallback != null) {
      widget._selectDateCallback!.call(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (initSelectedDateValue != widget.selectedDate) {
      selectedDate = widget.selectedDate;
    }

    double getGridHeight() {
      double result = widget.height -
          (widget._header == null
              ? 0
              : widget._header?.height == null
              ? 0
              : widget._header!.height!);
      return result;
    }

    TableRow generateHeaders() {
      return TableRow(
        children: <Widget>[
          for (var ttl in List<String>.of({
            "ПН",
            "ВТ",
            "СР",
            "ЧТ",
            "ПТ",
            "СБ",
            "ВС",
          }))
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              height: widget._header?.height,
              color: widget._header?.background ??
                  Theme.of(context).colorScheme.primaryContainer,
              child: Text(ttl, style: const TextStyle(fontSize: 16)),
            ),
        ],
      );
    }

    List<Widget> generateDays(List<Day> cells) {
      List<Widget> array = [];

      for (var cell in cells) {
        var cellwidget = Container(
          height: getGridHeight() / 6,
          padding: const EdgeInsets.all(1),
          child: NewHover(
            hover: HoverEffect(
              animated: AnimatedEffect(
                  isAnimated: true,
                  duration: 250,
              )),
            tap: widget.tap ??
                TapEffect(
                  onPressed: () => selectDay(cell.date),
                ),
            child:
            NewCellWidget(
                cell: cell,
                hover: widget.hover,
                tap: widget.tap,
                isSelected: widget.selectedDate != null && widget.selectedDate!.isSameDate(cell.date),
                child: widget?.children != null && widget!.children!.any((element) => element.date.isSameDate(cell.date))
                    ?  widget!.children!.firstWhere((element) => element.date.isSameDate(cell.date)) as Widget
                    : null),
          ),
        );

        array.add(cellwidget);
      }
      return array;
    }

    List<TableRow> generateTableRows() {
      var skip = 0;
      List<TableRow> rows = [];

      rows.add(generateHeaders());

      for (var _ in Iterable<int>.generate(6)) {
        var slice =
        widget._monthDays.skip(skip).take(7).toList();
        var days = generateDays(slice);
        var row = TableRow(children: days);
        skip += 7;
        rows.add(row);
      }
      return rows;
    }

    return
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Table(
          border: widget._border,
          columnWidths: <int, TableColumnWidth>{
            for (var indx in Iterable<int>.generate(6))
              indx: const FlexColumnWidth()
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: generateTableRows(),
        ),


    );
  }
}
