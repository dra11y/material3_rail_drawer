import 'package:flutter/material.dart';

class ScreenSizeChangedDetector extends StatelessWidget {
  const ScreenSizeChangedDetector({
    super.key,
    required this.isMobile,
    required this.onIsMobileChanged,
  });

  final bool isMobile;
  final void Function(bool) onIsMobileChanged;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final newMobile = MediaQuery.sizeOf(context).width < 600;
      if (newMobile != isMobile) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onIsMobileChanged(newMobile);
        });
      }
      return const SizedBox.shrink();
    });
  }
}
