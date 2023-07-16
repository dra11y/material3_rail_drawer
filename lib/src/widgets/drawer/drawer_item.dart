import 'package:flutter/material.dart';

import '../../navigation/navigation.dart';
import 'rail_drawer_button.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.hasBackButton,
    required this.drawerItemIndent,
    required this.index,
    required this.destination,
    required this.isSelected,
    this.isExpanded,
    required this.onPressed,
    this.isRoot = false,
    this.level = 0,
  });

  final bool hasBackButton;
  final double drawerItemIndent;
  final int index;
  final Destination destination;
  final bool isRoot;
  final int level;
  final bool isSelected;
  final bool? isExpanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => RailDrawerButton(
        level: level,
        drawerItemIndent: drawerItemIndent,
        extraIndent: hasBackButton ? drawerItemIndent * 2.5 : 0,
        index: index,
        isSelected: isSelected,
        isAccessibilityFocused: isSelected,
        icon: destination.icon,
        selectedIcon: destination.selectedIcon,
        expanderIcon: isRoot ? Icons.arrow_forward : null,
        label: destination.label,
        isExpanded: isExpanded,
        onPressed: onPressed,
      );
}
