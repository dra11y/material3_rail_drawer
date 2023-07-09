import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material3_rail_drawer/src/clamp_at_zero_extension.dart';

import 'destination.dart';
import 'drawer_components.dart';
import 'navigation_state.dart';

class Material3RailDrawerShell extends StatelessWidget {
  const Material3RailDrawerShell({
    super.key,
    required this.isMobile,
    required this.isDrawerOpen,
    required this.navigationState,
    this.navigationDrawer,
    required this.navigationShell,
    required this.onDestinationSelected,
    required this.onTapDrawerToggleButton,
  });

  final bool isMobile;
  final bool isDrawerOpen;
  final NavigationState navigationState;
  final Widget? navigationDrawer;
  final StatefulNavigationShell navigationShell;
  final ValueChanged<Destination> onDestinationSelected;
  final void Function(ScaffoldState) onTapDrawerToggleButton;

  @override
  Widget build(BuildContext context) {
    final railMinWidth = NavigationRailTheme.of(context).minWidth!;
    final drawerWidth = DrawerTheme.of(context).width!;
    final hasDrawer = navigationState.current.root.children.isNotEmpty;

    return Row(
      children: [
        SizedBox(
          width: railMinWidth,
          child: OverflowBox(
            key: ValueKey(isMobile),
            maxWidth: railMinWidth,
            alignment: Alignment.centerRight,
            child: isMobile
                ? null
                : Semantics(
                    container: true,
                    label: 'Primary navigation',
                    child: NavigationRail(
                      leading: ToggleDrawerButton(
                        isOpen: isDrawerOpen,
                        alignment: Alignment.center,
                        onPressed: hasDrawer ? onTapDrawerToggleButton : null,
                      ),
                      selectedIndex: navigationState.destinations
                          .indexOf(navigationState.current.root)
                          .clampAtZero,
                      onDestinationSelected: (value) {
                        onDestinationSelected(
                            navigationState.destinations[value]);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        ...navigationState.destinations.map(
                          (destination) => NavigationRailDestination(
                            padding: const EdgeInsets.all(8),
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(
                              destination.selectedIcon,
                              semanticLabel: 'selected,',
                            ),
                            label: Semantics(
                                label: '${destination.label},',
                                excludeSemantics: true,
                                child: Text(destination.label)),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
        if (navigationDrawer != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isDrawerOpen ? drawerWidth : 0,
            child: navigationDrawer!,
          ),
        Expanded(
          child: Semantics(
            container: true,
            child: navigationShell,
          ),
        ),
      ],
    );
  }
}
