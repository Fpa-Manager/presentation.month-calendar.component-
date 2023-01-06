import 'package:flutter/material.dart';
import 'content_widget.dart';
import 'day_widget.dart';
import 'model/month_grid_builder.dart';

class Cell extends StatelessWidget {
  final Widget? child;

  const Cell({super.key,
    required this.cell,
    this.child,
  });

  final GridCell cell;

  final ColorFilter _greyscale = const ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null)
          Content(
            child: cell.isInMonth &&
                cell.date.isAfter(
                    DateTime(DateTime.now().year, DateTime.now().month))
                ? child
                : ColorFiltered(
                colorFilter: _greyscale,
                child: child
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: Date(
            cell: cell,
          ),
        ),
      ],
    );
  }
}