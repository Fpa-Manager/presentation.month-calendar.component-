import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';
import 'package:system/system.dart' as system;
import '../../month_calendar.dart';
import 'cell_decoration_container.dart';
import 'cell_widget_info_inherited_widget.dart';
import 'day_widget.dart';
import 'dart:math';

class CellBehaviorWidget extends StatefulWidget implements MouseEvent {
  final SelectedEffect? select;
  @override
  final HoverEffect? hover;
  @override
  final TapEffect? tap;
  final system.Day cell;
  final Widget? child;

  const CellBehaviorWidget(
      {Key? key, this.hover, this.tap, this.select, required this.cell, required this.child})
      : super(key: key);

  @override
  State<CellBehaviorWidget> createState() => _CellBehaviorWidgetState();
}

class _CellBehaviorWidgetState extends State<CellBehaviorWidget> {
  var isSelected = false; // for inherited
  var isHovered = false;
  var isPressed = false;
  var widgetHeight = 0.0;
  var widgetWidth = 0.0;

  @override
  initState() {
    super.initState();
    //isSelected = widget.select?.selectedDate != null && widget.select?.selectedDate == true;
  }

  DateTime? selectedDayValue(DateTime date) =>
      widget.select?.selectedDate != null && widget.select?.selectedDate == date ? null : date;

  void selectDay(DateTime date) {
    if (isSelected == false) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    if (widget.select?.selectDateCallback != null) {
      widget.select?.selectDateCallback!.call(selectedDayValue(date));
    }
  }

  void _onPress() {
    if (widget.select?.isSelectable == true) selectDay(widget.cell.date);
    if (widget.tap?.isPressable == true) widget.tap?.onPressed?.call();
  }

  void _onPressDown(details) {
    setState(() {
      isPressed = true;
    });
  }

  void _onPressUp(details) {
    setState(() {
      isPressed = false;
    });
  }

  void _onPressCancel() {
    setState(() {
      isPressed = false;
    });
  }

  void _onHover() {
    setState(() {
      isHovered = true;
    });
  }

  void _onUnHover() {
    setState(() {
      isHovered = false;
    });
  }

  Widget? getSelectedContainer() {
    if (widget.select?.isSelectable == false) return null;
    return CellDecorationContainer(
      trigger: widget.select?.selectedDate?.isSameDate(widget.cell.date) ?? false,
      decoration: widget.select?.decoration,
    );
  }

  Widget? getHoveredContainer() {
    if (widget.hover?.isHoverable == false) return null;
    return CellDecorationContainer(
      trigger: isHovered,
      decoration: widget.hover?.decoration,
    );
  }

  Widget? getTappedContainer() {
    if (widget.tap?.isPressable == false) return null;
    return CellDecorationContainer(
      trigger: isPressed,
      decoration: widget.tap?.decoration,
    );
  }

  Widget getTree() {
    var widgetTree = getIfPressable();
    return CellWidgetInfo(
        isSelected: isSelected,
        isHovered: isHovered,
        width: widgetWidth,
        height: widgetHeight,
        child: widgetTree ?? Container());
  }

  Widget? getIfPressable() {
    if (widget.select?.isSelectable == true || widget.tap?.isPressable == true) {
      return NestedGestureDetector(
          opaque: widget.tap?.opacity,
          onTap: _onPress,
          onTapDown: _onPressDown,
          onTapUp: _onPressUp,
          onTapCancel: _onPressCancel,
          child:
          Container(
              color: const Color(0x00FFFFFF),
              child: getIfHoverable())
      );
    }
    return getIfHoverable();
  }

  Widget? getIfHoverable() {
    if (widget.hover?.isHoverable == true) {
      return MouseDetector(
          opaque: widget.hover?.opacity,
          onEnter: _onHover,
          onExit: _onUnHover,
          child:
          Container(
              color: const Color(0x00FFFFFF),
              child: widget.child));
    }
    return widget.child ?? Container();
  }

  double getCellRadian() {
    var a = pow(widgetHeight, 2);
    var b = pow(widgetWidth, 2);
    var value = sqrt(a + b);
    return value;
  }

  double percent(double x, double y) => y * x / 100;
  double getPadding() {
    var cellRadian = getCellRadian();
    var percent5ofRadian = percent(4, cellRadian);

    double result = percent(percent5ofRadian, cellRadian);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cellConstraints) {
      widgetHeight = cellConstraints.maxHeight;
      widgetWidth = cellConstraints.maxWidth;
      return Stack(
        alignment: Alignment.bottomLeft,
        children: [
          if (widget.hover?.isHoverable == true) getHoveredContainer()!,
          if (widget.tap?.isPressable == true) getTappedContainer()!,
          if (widget.select?.isSelectable == true) getSelectedContainer()!,

          Container(
            padding: EdgeInsets.only(top: getPadding() / 2, right: getPadding() / 3),
            alignment: Alignment.bottomRight,
            child: Date( cell: widget.cell,),
          ),

          getTree(),
        ],
      );
    });
  }
}