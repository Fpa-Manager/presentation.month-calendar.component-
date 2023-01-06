
import 'package:flutter/widgets.dart';

class Content extends StatelessWidget {
  final Widget? child;

  const Content({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 15, bottom: 10, top: 1),
      child: Column(
        children: [
          const Spacer(
            flex: 3,
          ),
          if (child == null)
            const Spacer(
              flex: 4,
            )
          else
            Expanded(
              flex: 4,
              child: child!,
            ),
        ],
      ),
    );
  }
}