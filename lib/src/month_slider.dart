import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:system/system.dart';

class MonthSlider extends StatelessWidget {
  final int year;
  final int month;

  final void Function(int, int)? _previousMonthCallBack;
  final void Function(int, int)? _nextMonthCallBack;

  const MonthSlider(
      {super.key,
      required this.year,
      required this.month,
      void Function(int, int)? previousMonthCallBack,
      void Function(int, int)? nextMonthCallBack})
      : _previousMonthCallBack = previousMonthCallBack,
        _nextMonthCallBack = nextMonthCallBack;

  @override
  Widget build(BuildContext context) {
    var current = DateTime(year, month);

    void addMonth(int count) {
      if (count <= 0) return;
      current = current.month + count > 12
          ? DateTime(current.year + 1, current.month + count - 12)
          : DateTime(current.year, current.month + count);

      if (_nextMonthCallBack != null) {
        _nextMonthCallBack!(current.year, current.month);
      }
    }

    void subtractMonth(int count) {
      if (count <= 0) return;
      current = current.month - count <= 0
          ? DateTime(current.year - 1, 12 + (current.month - count))
          : DateTime(current.year, current.month - count);

      if (_previousMonthCallBack != null) {
        _previousMonthCallBack!(current.year, current.month);
      }
    }

    return SizedBox(
      width: 380,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            //color: Theme.of(context).colorScheme.primaryContainer,
            //tapColor: Colors.amber,
            //hoverColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              subtractMonth(1);
            },
            width: 37,
            height: 37,
            child: const Icon(
              PhosphorIcons.caretLeftLight,
              size: 20,
            ),
          ),
          Text(
            current.toFormatString(pattern: DataFormatPattern.MMYY).toUpperFirstLetter(),
            style:
                Theme.of(context).textTheme.headline4?.copyWith(fontSize: 36),
          ),
          FlatButton(
            color: Theme.of(context).colorScheme.primaryContainer,
            tapColor: Colors.amber,
            hoverColor: Colors.blue,
            onPressed: () => addMonth(1),
            width: 37,
            height: 37,
            child: const Icon(
              PhosphorIcons.caretRightLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // static Map<int, String> monthName = {
  //   1: "Январь",
  //   2: "Февраль",
  //   3: "Март",
  //   4: "Апрель",
  //   5: "Май",
  //   6: "Июнь",
  //   7: "Июль",
  //   8: "Август",
  //   9: "Сентябрь",
  //   10: "Октябрь",
  //   11: "Ноябрь",
  //   12: "Декабрь",
  // };
}