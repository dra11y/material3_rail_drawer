import 'package:flutter/material.dart';

import '../../material3/material3.dart';
import '../../navigation/navigation.dart';
import 'drawer_root_list.dart';
import 'drawer_sub_list.dart';
import 'toggle_drawer_button.dart';

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

class Material3RailDrawerDrawer extends StatefulWidget {
  const Material3RailDrawerDrawer({
    super.key,
    required this.windowSize,
    required this.navigationState,
    required this.animationTheme,
    required this.drawerItemIndent,
    required this.onDestinationSelected,
    this.onTapDrawerToggleButton,
  });

  final WindowSize windowSize;
  final NavigationState navigationState;
  final RailDrawerAnimationTheme animationTheme;
  final double drawerItemIndent;
  final ValueChanged<Destination> onDestinationSelected;
  final void Function(ScaffoldState)? onTapDrawerToggleButton;

  @override
  State<Material3RailDrawerDrawer> createState() =>
      _Material3RailDrawerDrawerState();
}

class _Material3RailDrawerDrawerState extends State<Material3RailDrawerDrawer>
    with SingleTickerProviderStateMixin {
  late bool isRoot = widget.windowSize.isCompact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = NavigationDrawerTheme.of(context).backgroundColor ??
        DrawerTheme.of(context).backgroundColor ??
        colorScheme.surface;
    final surfaceTintColor = colorScheme.surfaceTint;
    final elevation = NavigationDrawerTheme.of(context).elevation ?? 1.0;

    return Semantics(
      container: true,
      label: widget.windowSize.isMediumOrExpanded
          ? null
          : 'Secondary navigation: ${widget.navigationState.current.root.label}',
      child: Drawer(
        child: OverflowBox(
          maxWidth: DrawerTheme.of(context).width!,
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              if (widget.windowSize.isCompact)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
                  child: ToggleDrawerButton(
                    isOpen: true,
                    onPressed: widget.onTapDrawerToggleButton,
                  ),
                ),
              Expanded(
                child: Semantics(
                  container: true,
                  child: widget.windowSize.isCompact
                      ? Navigator(
                          pages: [
                            ColorMaterialPage(
                              color: backgroundColor,
                              elevation: elevation,
                              surfaceTintColor: surfaceTintColor,
                              child: DrawerRootList(
                                key: ValueKey(widget
                                    .navigationState.current.root.fullPath),
                                drawerItemIndent: widget.drawerItemIndent,
                                navigationState: widget.navigationState,
                                onDestinationSelected: (destination) {
                                  if (destination.children.isNotEmpty) {
                                    setState(() {
                                      isRoot = false;
                                    });
                                  }
                                  widget.onDestinationSelected(destination);
                                },
                              ),
                            ),
                            if (!isRoot)
                              ColorMaterialPage(
                                  color: backgroundColor,
                                  elevation: elevation,
                                  surfaceTintColor: surfaceTintColor,
                                  child: DrawerSubList(
                                    key: ValueKey(widget
                                        .navigationState.current.root.fullPath),
                                    drawerItemIndent: widget.drawerItemIndent,
                                    hasBackButton: true,
                                    animationTheme: widget.animationTheme,
                                    navigationState: widget.navigationState,
                                    onDestinationSelected:
                                        widget.onDestinationSelected,
                                  )),
                          ],
                          onPopPage: (route, result) {
                            setState(() {
                              isRoot = true;
                            });
                            return route.didPop(result);
                          },
                        )
                      : DrawerSubList(
                          drawerItemIndent: widget.drawerItemIndent,
                          hasBackButton: false,
                          animationTheme: widget.animationTheme,
                          navigationState: widget.navigationState,
                          onDestinationSelected: widget.onDestinationSelected,
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
