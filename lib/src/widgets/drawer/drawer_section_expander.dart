import 'package:flutter/material.dart';

import '../../material3/material3.dart';

class DrawerSectionExpander extends StatefulWidget {
  const DrawerSectionExpander({
    super.key,
    required this.isExpanded,
    required this.animationTheme,
    required this.children,
  });

  final bool isExpanded;
  final RailDrawerAnimationTheme animationTheme;
  final List<Widget> children;

  @override
  State<DrawerSectionExpander> createState() => _DrawerSectionExpanderState();
}

class _DrawerSectionExpanderState extends State<DrawerSectionExpander>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: widget.animationTheme.expandCollapseItemDuration,
        vsync: this);
    animation = CurvedAnimation(
        parent: controller,
        curve: widget.animationTheme.expandCollapseItemCurve);
  }

  @override
  void dispose() {
    animation.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpanded) {
      if (!controller.isCompleted) {
        controller.forward();
      }
    } else {
      if (!controller.isDismissed) {
        controller.reverse();
      }
    }
    return SizeTransition(
      axis: Axis.vertical,
      axisAlignment: -1,
      sizeFactor: animation,
      child: Column(
        children: widget.children,
      ),
    );
  }
}
