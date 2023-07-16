import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../navigation/navigation.dart';
import 'drawer_item.dart';

class DrawerRootList extends StatelessWidget {
  const DrawerRootList({
    super.key,
    required this.navigationState,
    required this.drawerItemIndent,
    required this.onDestinationSelected,
  });

  final NavigationState navigationState;
  final double drawerItemIndent;
  final ValueChanged<Destination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...navigationState.destinations.mapIndexed(
          (index, destination) => DrawerItem(
            hasBackButton: false,
            drawerItemIndent: drawerItemIndent,
            index: index,
            destination: destination,
            isRoot: true,
            isSelected: destination == navigationState.current,
            onPressed: () => onDestinationSelected(destination),
          ),
        ),
      ],
    );
  }
}
