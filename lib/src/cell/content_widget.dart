
import 'package:flutter/widgets.dart';

class Content extends StatelessWidget {
  final Widget? child;

  const Content({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: child
      // Column(
      //   children: [
      //     const Spacer(
      //       flex: 3,
      //     ),
      //     if (child == null)
      //       const Spacer(
      //         flex: 3,
      //       )
      //     else
      //       Expanded(
      //         flex: 6,
      //         child: child!,
      //       ),
      //   ],
      // ),
    );
  }
}