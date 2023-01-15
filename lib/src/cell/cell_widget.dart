
import 'package:flutter/material.dart';
import 'package:mytheme/component/overed_container.dart';
import 'package:mytheme/theme.dart';
import 'package:system/system.dart' as system;
import 'cell_widget_info_inherited_widget.dart';
import 'content_widget.dart';
import 'day_widget.dart';
import '../theme.dart';
import 'dart:math';

class NewCellWidget extends StatelessWidget implements MouseEvent {
  final system.Day cell;
  final Widget? child;
  final bool isSelected;

  @override
  final HoverEffect? hover;
  @override
  final TapEffect? tap;

  const NewCellWidget({super.key,
    required this.cell,
    this.child,
    this.hover,
    this.tap,
    this.isSelected = false
  });

  @override
  Widget build(BuildContext context) {

    var widgetHeight = 0.0;
    var widgetWidth = 0.0;

    double getCellRadian(){
      var a = pow(widgetHeight, 2);
      var b = pow(widgetWidth, 2);
      var value = sqrt(a+b);
      return value;
    }

    double percent(double x, double y) => y * x / 100;

    double getPadiing(){
      var cellRadian = getCellRadian();
      var percent5ofRadian = percent(4, cellRadian);

      double result = percent(percent5ofRadian,cellRadian);

      return result;
    }

    Color selectedDayBorderColor() {
      var currentDayColor = Theme.of(context).extension<MontCalendarTheme>()?.currentDayColor;
      var surfaceColor = Theme.of(context).colorScheme.surface;
      return currentDayColor ?? surfaceColor;
    }

    BoxDecoration? getCellDayDecoration(system.Day cell) {
      var decoration = BoxDecoration(
          border: Border.all(
            color: isSelected
                ? selectedDayBorderColor()
                : const Color(0x00ffffff),
            width: 2.0,
          ));
      return decoration;
    }

    var isHovered = false;

    return LayoutBuilder(
        builder: (context, cellConstraints) {
          widgetHeight = cellConstraints.maxHeight;
          widgetWidth = cellConstraints.maxWidth;
          return OveredContainer(
            hover: HoverEffect(
              decoration: const BoxDecoration(),
              onEnterFunction: () => isHovered = true,
              onExitFunction: () => isHovered = false,
            ),
            child: CellWidgetInfo(
              isSelected: isSelected,
              width: widgetWidth,
              height: widgetHeight,
              isHover: isHovered,
              child: Container(
                decoration: getCellDayDecoration(cell),
                child: NewHover(
                  hover: hover,
                  tap: tap,
                  child: Padding(
                    padding: EdgeInsets.all(getPadiing()),
                    child: Cell(
                        cell: cell,
                        child: child),
                  ),
                ),
              ),
            ),
          );
        });
  }
}




class Cell extends StatelessWidget {
  final Widget? child;

  const Cell({super.key,
    required this.cell,
    this.child,
  });

  final system.Day cell;

  final ColorFilter _greyscale = const ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        if (child != null)
          Content(
            child: cell.isInMonth && cell.date.isAfter(DateTime.now())
                ? child
                : ColorFiltered(
                  colorFilter: _greyscale,
                  child: child),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: Date( cell: cell,),),
      ],
    );
  }
}
