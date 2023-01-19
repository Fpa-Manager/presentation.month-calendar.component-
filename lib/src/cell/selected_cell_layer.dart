
import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';

class SelectedCellLayer extends StatefulWidget {
  final BoxDecoration? decoration;
  final void Function()? selectDateCallback;
  final void Function()? unSelectDateCallback;
  final Widget? child;

  const SelectedCellLayer({Key? key,
    this.decoration,
    this.selectDateCallback,
    this.unSelectDateCallback,
    this.child}) : super(key: key);
  @override
  State<SelectedCellLayer> createState() => _SelectedCellLayerState();
}

class _SelectedCellLayerState extends State<SelectedCellLayer> {
  bool isSelected = false;

  void _select(){
    setState(() {
      isSelected = true;
    });
    if(widget.selectDateCallback != null){
      widget.selectDateCallback!.call();
    }
  }

  void _unSelect(){
    setState(() {
      isSelected = false;
    });
    if(widget.unSelectDateCallback != null){
      widget.unSelectDateCallback!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewHover(
        hover: const HoverEffect(decoration: BoxDecoration()),
        tap: TapEffect(
          decoration: const BoxDecoration(),
          onPressed: isSelected ? _unSelect : _select,
        ),
        child: Container(
          decoration: isSelected ? widget.decoration : null,
          child: widget.child,
        )
    );
  }
}
