
import 'package:flutter/material.dart';
import 'package:mytheme/theme.dart';

class HoverCellLayer extends StatefulWidget {
  final BoxDecoration? decoration;
  final void Function()? onHoverCallback;
  final void Function()? onUnHoverCallback;
  final Widget? child;

  const HoverCellLayer({Key? key, this.decoration, this.onHoverCallback, this.onUnHoverCallback, this.child }) : super(key: key);

  @override
  State<HoverCellLayer> createState() => _HoverCellLayerState();
}

class _HoverCellLayerState extends State<HoverCellLayer> {

  bool isHovered = false;

  void _hover(){
    setState(() {
      isHovered = true;
    });
    if(widget.onHoverCallback != null){
      widget.onHoverCallback!.call();
    }
  }
  void _unHover(){
    setState(() {
      isHovered = false;
    });
    if(widget.onUnHoverCallback != null){
      widget.onUnHoverCallback!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewHover(
        hover: HoverEffect(
          decoration: isHovered ? widget.decoration : const BoxDecoration(),
          onEnterFunction: _hover,
          onExitFunction: _unHover,
        ),
        tap: const TapEffect(
          decoration: BoxDecoration(),
        ),
        child: widget.child!,
        );
  }
}
