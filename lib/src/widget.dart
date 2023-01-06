import 'package:flutter/material.dart';
import 'package:month_calendar/src/theme.dart';
import 'package:mytheme/component/hovered_container.dart';
import 'package:mytheme/component/mouse_event.dart';
import 'package:system/system.dart' as system;
import 'cell_widget.dart';
import 'model/month_calendar_model_mixin.dart';
import 'model/month_grid_builder.dart';

class MonthCalendar extends StatefulWidget implements MouseEvent {
  final MonthCalendarHeader? _header;
  final TableBorder? _border;

  @override
  final HoverEffect? hover;
  @override
  final TapEffect? tap;

  final void Function(DateTime?)? _selectDateCallback;
  final DateTime? selectedDate;

  final MonthGridBuilder _calendarGridBuilder;

  final Iterable<Dated>? children;

  MonthCalendar(
      {super.key,
      required int year,
      required int month,
      this.selectedDate,
      HoverEffect? hoverDayEffect,
      TapEffect? tapDayEffect,
      void Function(DateTime?)? selectDateCallback,
      List<DateTime>? holidays,
      this.children,
      MonthCalendarHeader? header,
      TableBorder? border})
      : _header = header,
        hover = hoverDayEffect,
        _selectDateCallback = selectDateCallback,
        tap = tapDayEffect,
        _border = border,
        _calendarGridBuilder = MonthGridBuilder(year, month, holidays: holidays);

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late Iterable<Dated> chl;
  DateTime? initSelectedDateValue;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    chl = widget.children ?? [];
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
    var widgetHeight = 0.0;

    if (initSelectedDateValue != widget.selectedDate) {
      selectedDate = widget.selectedDate;
    }

    double getGridHeight() {
      double result = widgetHeight -
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

    List<Widget> generateDays(List<GridCell> cells) {
      List<Widget> array = [];

      Color weekendsBorderColor() =>
          Theme.of(context).extension<MontCalendarTheme>()?.currentDayColor
            ?? Theme.of(context).colorScheme.surface;

      BoxDecoration? getCellDayDecoration(GridCell cell) {
        var decoration = const BoxDecoration();
        if (cell.date.weekday == 6) {

        }
        if (cell.date.isSameDate(selectedDate)) {
          decoration = decoration.copyWith(
              border: Border.all(
            color: weekendsBorderColor(),
            width: 2.0,
          ));
        }
        return decoration;
        }

      for (var cell in cells) {
        var widget = Container(
          height: getGridHeight() / 6,
          padding: const EdgeInsets.all(1),
          child: Stack(
              children: [
            Container(
              decoration: getCellDayDecoration(cell),
              child: HoveredContainer(
                //opaque: true,
                tap: this.widget.tap ??
                    TapEffect(
                        onPressed: () => selectDay(cell.date),
                    ),
                child: Cell(
                    cell: cell,
                    child: chl.any((element) => element.date.isSameDate(cell.date))
                        ? chl.firstWhere((element) => element.date.isSameDate(cell.date)) as Widget
                        : null),
              ),
            ),

          ]),
        );

        array.add(widget);
      }
      return array;
    }

    List<TableRow> generateTableRows() {
      var skip = 0;
      List<TableRow> rows = [];

      rows.add(generateHeaders());

      for (var _ in Iterable<int>.generate(6)) {
        var slice =
            widget._calendarGridBuilder.getDates().skip(skip).take(7).toList();
        var days = generateDays(slice);
        var row = TableRow(children: days);
        skip += 7;
        rows.add(row);
      }
      return rows;
    }

    return LayoutBuilder(builder: (ctx, monthConstraints) {
      widgetHeight = monthConstraints.maxHeight;
      return Theme(
        data: Theme.of(context).copyWith(
          extensions: [MontCalendarTheme.light],
          colorScheme: Theme.of(context).colorScheme.copyWith(
            surface: Colors.brown
          )
        ),
        child: ClipRRect(
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
        ),
      );
    });
  }
}



class MonthCalendarHeader {
  final double? height;
  final Color? background;

  MonthCalendarHeader({this.height = 20, this.background});
}
