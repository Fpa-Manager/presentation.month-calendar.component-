
import 'package:flutter/material.dart';

class CellDecorationContainer extends StatelessWidget {
  final bool trigger;
  final BoxDecoration? decoration;
  const CellDecorationContainer({Key? key, required this.trigger, this.decoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: trigger ? decoration : null,
    );
  }
}
