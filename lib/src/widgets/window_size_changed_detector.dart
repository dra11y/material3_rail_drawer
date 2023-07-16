import 'package:flutter/material.dart';

import '../material3/material3.dart';

class WindowSizeChangedDetector extends StatelessWidget {
  const WindowSizeChangedDetector({
    super.key,
    required this.windowSize,
    required this.onChanged,
  });

  final WindowSize windowSize;
  final void Function(WindowSize) onChanged;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final newWindowSize =
          WindowSize.fromWidth(MediaQuery.sizeOf(context).width);
      if (newWindowSize != windowSize) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onChanged(newWindowSize);
        });
      }
      return const SizedBox.shrink();
    });
  }
}
