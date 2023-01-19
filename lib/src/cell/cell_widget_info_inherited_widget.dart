import 'package:flutter/material.dart';

class CellWidgetInfo extends InheritedWidget {
  const CellWidgetInfo({
    super.key,
    required this.isSelected,
    required this.isHovered,
    required this.width,
    required this.height,
    required Widget child,
  }) : super(child: child);

  final bool isSelected;
  final double width;
  final double height;
  final bool isHovered;

  static CellWidgetInfo? of(BuildContext context) {
    var item = context.dependOnInheritedWidgetOfExactType<CellWidgetInfo>();
    return item;
  }

  @override
  bool updateShouldNotify(covariant CellWidgetInfo oldWidget) {
    return isSelected != oldWidget.isSelected
           || isHovered != oldWidget.isHovered
           || width != oldWidget.width
           || height != oldWidget.height;
  }
}
