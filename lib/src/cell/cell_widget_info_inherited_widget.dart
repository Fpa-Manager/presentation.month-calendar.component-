import 'package:flutter/material.dart';

class CellWidgetInfo extends InheritedWidget {
  const CellWidgetInfo({
    super.key,
    required this.isSelected,
    required this.isHover,
    required this.width,
    required this.height,
    required Widget child,
  }) : super(child: child);

  final bool isSelected;
  final double width;
  final double height;
  final bool isHover;

  static CellWidgetInfo? of(BuildContext context) {
    var item = context.dependOnInheritedWidgetOfExactType<CellWidgetInfo>();
    return item;
  }

  @override
  bool updateShouldNotify(covariant CellWidgetInfo oldWidget) {
    return false; // isSelected != oldWidget.isSelected
                      // || width != oldWidget.width
                      // || height != oldWidget.height;
  }
}
