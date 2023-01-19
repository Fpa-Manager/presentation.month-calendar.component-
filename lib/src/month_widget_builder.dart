import 'package:flutter/material.dart';
import 'package:month_calendar/month_calendar.dart';
import 'package:mytheme/component/mouse_event.dart';
import 'package:system/system.dart' as system;
import 'package:system/system.dart';
import 'cell/cell_widget.dart';

class MonthCalendarBuilder extends StatefulWidget {
  final MonthCalendarHeader? _header;
  final TableBorder? _border;
  final List<Day> _monthDays;
  final Iterable<CellContent>? children;
  final double height;
  final double width;

  final SelectedEffect? select;
  final HoverEffect? hover;
  final TapEffect? tap;

  const MonthCalendarBuilder(
      {super.key,
        required this.height,
        required this.width,
        required List<Day> monthDays,
        this.children,
        this.select,
        this.hover,
        this.tap,
        MonthCalendarHeader? header,
        TableBorder? border})
      : _header = header,
        _border = border,
        _monthDays = monthDays;

  @override
  State<MonthCalendarBuilder> createState() => _MonthCalendarBuilderState();
}

class _MonthCalendarBuilderState extends State<MonthCalendarBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              color: widget._header?.background ?? Theme.of(context).colorScheme.primaryContainer,
              child: Text(ttl, style: const TextStyle(fontSize: 16)),
            ),
        ],
      );
    }

    List<Widget> generateDays(List<Day> cells) {
      List<Widget> array = [];

      for (var cell in cells) {
        var cellwidget = SizedBox(
          height: getGridHeight() / 6,
          child: CellBehaviorWidget(
              hover: widget.hover,
              tap: widget.tap,
              select: widget.select,
              cell: cell,
              child: widget.children != null &&
                  widget.children!.any((element) => element.date.isSameDate(cell.date))
                  ? widget.children!.firstWhere((element) => element.date.isSameDate(cell.date))
              as Widget
                  : null),
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
        var slice = widget._monthDays.skip(skip).take(7).toList();
        var days = generateDays(slice);
        var row = TableRow(children: days);
        skip += 7;
        rows.add(row);
      }
      return rows;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
      child: Table(
        border: widget._border,
        columnWidths: <int, TableColumnWidth>{
          for (var indx in Iterable<int>.generate(6)) indx: const FlexColumnWidth()
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        children: generateTableRows(),
      ),
    );
  }
}
