//
// import 'package:flutter/material.dart';
// import 'package:mytheme/theme.dart';
// import 'dumm_month_callendar.dart';
// import 'model/month_calendar_header.dart';
// import 'model/month_calendar_model_mixin.dart';
// import 'month_widget_builder.dart';
// import 'theme.dart';
// import 'package:system/system.dart';
//
// class MonthCalendar extends StatelessWidget implements MouseEvent {
//   final MonthCalendarHeader? _header;
//   final TableBorder? _border;
//   final SelectedEffect? select;
//   @override
//   final HoverEffect? hover;
//   @override
//   final TapEffect? tap;
//   //final void Function(DateTime?)? _selectDateCallback;
//   final DateTime? selectedDate;
//   final List<Day> _monthDays;
//   final Iterable<CellContent>? children;
//
//   MonthCalendar(
//       { super.key,
//         required int year,
//         required int month,
//         this.selectedDate,
//         this.select,
//         HoverEffect? hoverDayEffect,
//         TapEffect? tapDayEffect,
//         //void Function(DateTime?)? selectDateCallback,
//         List<DateTime>? holidays,
//         this.children,
//         MonthCalendarHeader? header,
//         TableBorder? border})
//       : _header = header,
//         hover = hoverDayEffect,
//         //_selectDateCallback = selectDateCallback,
//         tap = tapDayEffect,
//         _border = border,
//         _monthDays = Calendar(holidays: holidays).getMonth(year, month, MonthVariant.calendarGrid);
//
//   @override
//   Widget build(BuildContext context) {
//
//     var widgetHeight = 0.0;
//     var widgetWidth = 0.0;
//
//     return LayoutBuilder(builder: (context, monthConstraints) {
//       widgetHeight = monthConstraints.maxHeight;
//       widgetWidth = monthConstraints.maxWidth;
//       return Theme(
//         data: Theme.of(context).copyWith(
//             extensions: [MontCalendarTheme.light],
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                 surface: Colors.brown
//             )
//         ),
//         child: MonthBody(
//           height: widgetHeight,
//           width: widgetWidth,
//           monthDays: _monthDays,
//           selectedDate: selectedDate,
//           select: select,
//           hover: hover,
//           tap: tap,
//           //selectDateCallback: _selectDateCallback,
//           children: children,
//           header: _header,
//           border: _border,
//         ),
//       );
//     });
//   }
// }
