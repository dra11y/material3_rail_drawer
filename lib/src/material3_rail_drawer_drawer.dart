import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material3_rail_drawer/src/navigation_state.dart';

import 'destination.dart';
import 'drawer_components.dart';

class ColorMaterialPage extends MaterialPage {
  ColorMaterialPage({
    required Color color,
    required double elevation,
    required Color surfaceTintColor,
    required Widget child,
  }) : super(
          child: Material(
            color: color,
            elevation: elevation,
            surfaceTintColor: surfaceTintColor,
            child: child,
          ),
        );
}

class Material3RailDrawerDrawer extends HookWidget {
  const Material3RailDrawerDrawer({
    super.key,
    required this.isModal,
    required this.navigationState,
    required this.drawerItemIndent,
    required this.onDestinationSelected,
    this.onTapDrawerToggleButton,
  });

  final bool isModal;
  final NavigationState navigationState;
  final double drawerItemIndent;
  final ValueChanged<Destination> onDestinationSelected;
  final void Function(ScaffoldState)? onTapDrawerToggleButton;

  @override
  Widget build(BuildContext context) {
    final isRoot = useState(isModal);
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = NavigationDrawerTheme.of(context).backgroundColor ??
        DrawerTheme.of(context).backgroundColor ??
        colorScheme.surface;
    final surfaceTintColor = colorScheme.surfaceTint;
    final elevation = NavigationDrawerTheme.of(context).elevation ?? 1.0;

    return Semantics(
      container: true,
      label: isModal
          ? null
          : 'Secondary navigation: ${navigationState.current.root.label}',
      child: Drawer(
        child: OverflowBox(
          maxWidth: DrawerTheme.of(context).width!,
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              if (isModal)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
                  child: ToggleDrawerButton(
                    isOpen: true,
                    onPressed: onTapDrawerToggleButton,
                  ),
                ),
              Expanded(
                child: Semantics(
                  container: true,
                  child: isModal
                      ? Navigator(
                          pages: [
                            ColorMaterialPage(
                              color: backgroundColor,
                              elevation: elevation,
                              surfaceTintColor: surfaceTintColor,
                              child: DrawerRootList(
                                drawerItemIndent: drawerItemIndent,
                                navigationState: navigationState,
                                onDestinationSelected: (destination) {
                                  if (destination.children.isNotEmpty) {
                                    isRoot.value = false;
                                  }
                                  onDestinationSelected(destination);
                                },
                              ),
                            ),
                            if (!isRoot.value)
                              ColorMaterialPage(
                                  color: backgroundColor,
                                  elevation: elevation,
                                  surfaceTintColor: surfaceTintColor,
                                  child: DrawerSubList(
                                    drawerItemIndent: drawerItemIndent,
                                    hasBackButton: true,
                                    navigationState: navigationState,
                                    onDestinationSelected:
                                        onDestinationSelected,
                                  )),
                          ],
                          onPopPage: (route, result) {
                            isRoot.value = true;
                            return route.didPop(result);
                          },
                        )
                      : DrawerSubList(
                          drawerItemIndent: drawerItemIndent,
                          hasBackButton: false,
                          navigationState: navigationState,
                          onDestinationSelected: onDestinationSelected,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
