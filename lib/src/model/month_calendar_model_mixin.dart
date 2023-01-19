import 'package:flutter/cupertino.dart';

import '../cell/cell_widget_info_inherited_widget.dart';

mixin CellContent {
  late final DateTime date;

  bool getIsHovered(BuildContext context) => CellWidgetInfo.of(context)?.isHovered ?? false;

  bool getIsSelected(BuildContext context) => CellWidgetInfo.of(context)?.isSelected ?? false;

  double getCellWidth(BuildContext context) => CellWidgetInfo.of(context)?.width ?? 0;

  double getCellHeight(BuildContext context) => CellWidgetInfo.of(context)?.height ?? 0;
}
