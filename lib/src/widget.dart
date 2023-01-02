import 'package:flutter/material.dart';
import 'package:month_calendar/src/theme.dart';
import 'package:mytheme/component/hovered_container.dart';
import 'package:mytheme/component/mouse_event.dart';
import 'package:system/system.dart' as system;
import 'month_calendar_model_mixin.dart';
import 'month_grid_builder.dart';

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

      Color weekendsBorderColor() {
        if (Theme.of(context).extension<MontCalendarTheme>() != null) {
          return Theme.of(context).extension<MontCalendarTheme>()!.currentDayColor;
        }
        else {
          return Theme.of(context).colorScheme.surface;
        }
      }

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
                // hover: this.widget.hover ??
                //     HoverEffect(
                //         decoration: BoxDecoration(
                //             color:
                //                 Theme.of(context).colorScheme.surfaceVariant,
                //             border: Border(
                //               bottom: BorderSide(
                //                 color: Theme.of(context)
                //                     .extension<ThemeColors>()!
                //                     .currentDayColor,
                //                 width: 2.0,
                //               ),
                //             ))),
                tap: this.widget.tap ??
                    TapEffect(
                        onPressed: () => selectDay(cell.date),
                        // decoration: BoxDecoration(
                        //     color: const Color(0xFFF4F4F4),
                        //     // border: Border(
                        //     //   bottom: BorderSide(
                        //     //     color: Theme.of(context)
                        //     //         .extension<ThemeColors>()!
                        //     //         .currentDayColor,
                        //     //     width: 2.0,
                        //     //   ),
                        //     // )
                        // )
                    ),
                child: Container(),
              ),
            ),
            _CalendarDay(
                cell: cell,
                child: chl.any((element) => element.date.isSameDate(cell.date))
                    ? chl.firstWhere(
                            (element) => element.date.isSameDate(cell.date))
                        as Widget
                    : null)
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
      return ClipRRect(
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
    });
  }
}

class _CalendarDay extends StatelessWidget {
  final Widget? child;

  const _CalendarDay({
    required this.cell,
    this.child,
  });

  final GridCell cell;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null)
          () {
            return _TableCellContent(
                child: cell.isInMonth &&
                        cell.date.isAfter(
                            DateTime(DateTime.now().year, DateTime.now().month))
                    ? child
                    : Theme(
                        data: Theme.of(context)
                            .copyWith(extensions: <ThemeExtension<dynamic>>[
                          MontCalendarTheme.inactive,
                        ]),
                        child: child!));
          }(),
        Align(
          alignment: Alignment.bottomRight,
          child: _TableCellDate(
            cell: cell,
          ),
        ),
      ],
    );
  }
}

class _TableCellDate extends StatelessWidget {
  final GridCell cell;

  const _TableCellDate({required this.cell});

  bool isCurrentDay(DateTime date) => date.isSameDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(top: 2, right: 2),
      child: Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        decoration: isCurrentDay(cell.date) && cell.isInMonth
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:
                    Theme.of(context).extension<MontCalendarTheme>()?.currentDayColor)
            : null,
        child: Text(
          cell.date.day.toString(),
          style: cell.isInMonth == false
                  ? TextStyle(color: Colors.grey.shade400, fontSize: 14)
                  : cell.isWeekend != null && cell.isWeekend!
                    ? const TextStyle( color: Colors.red, fontSize: 18)
                    : const TextStyle( color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}

class _TableCellContent extends StatelessWidget {
  final Widget? child;

  const _TableCellContent({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 15, bottom: 10, top: 1),
      child: Column(
        children: [
          const Spacer(
            flex: 3,
          ),
          if (child == null)
            const Spacer(
              flex: 4,
            )
          else
            Expanded(
              flex: 4,
              child: child!,
            ),
        ],
      ),
    );
  }
}

class MonthCalendarHeader {
  final double? height;
  final Color? background;

  MonthCalendarHeader({this.height = 20, this.background});
}
