import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../material3/material3.dart';
import '../navigation/navigation.dart';
import '../util/util.dart';
import 'drawer/toggle_drawer_button.dart';

class Material3RailDrawerShell extends StatelessWidget {
  const Material3RailDrawerShell({
    super.key,
    required this.windowSize,
    required this.isDrawerOpen,
    required this.navigationState,
    required this.animationTheme,
    this.inlineNavigationDrawer,
    required this.navigationShell,
    required this.onDestinationSelected,
    required this.onTapDrawerToggleButton,
  });

  final WindowSize windowSize;
  final bool isDrawerOpen;
  final NavigationState navigationState;
  final RailDrawerAnimationTheme animationTheme;
  final Widget? inlineNavigationDrawer;
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
            key: ValueKey(windowSize),
            maxWidth: railMinWidth,
            alignment: Alignment.centerRight,
            child: windowSize.isCompact
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
        if (inlineNavigationDrawer != null)
          AnimatedContainer(
            duration: animationTheme.inlineDrawerOpenCloseDuration,
            curve: animationTheme.inlineDrawerOpenCloseCurve,
            width: isDrawerOpen ? drawerWidth : 0,
            child: inlineNavigationDrawer!,
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
