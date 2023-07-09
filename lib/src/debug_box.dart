import 'package:flutter/material.dart';

class DebugBox extends StatelessWidget {
  const DebugBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
        ),
        child: child,
      );
}
