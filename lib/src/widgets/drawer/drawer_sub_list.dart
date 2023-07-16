import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../material3/material3.dart';
import '../../navigation/navigation.dart';
import 'drawer_item.dart';
import 'drawer_section_expander.dart';
import 'rail_drawer_button.dart';

class DrawerSubList extends StatefulWidget {
  const DrawerSubList({
    super.key,
    required this.hasBackButton,
    required this.animationTheme,
    required this.drawerItemIndent,
    required this.navigationState,
    required this.onDestinationSelected,
  });

  final bool hasBackButton;
  final RailDrawerAnimationTheme animationTheme;
  final double drawerItemIndent;
  final NavigationState navigationState;
  final ValueChanged<Destination> onDestinationSelected;

  @override
  State<DrawerSubList> createState() => _DrawerSubListState();
}

class _DrawerSubListState extends State<DrawerSubList> {
  late Map<String, ListView> listViews;
  late final CatmullRomCurve switchInCurve;
  late final CatmullRomCurve switchOutCurve;

  @override
  void initState() {
    super.initState();
    switchInCurve = CatmullRomCurve.precompute(
        widget.animationTheme.inlineDrawerSwitchInCurveOffsets);
    switchOutCurve = CatmullRomCurve.precompute(
        widget.animationTheme.inlineDrawerSwitchOutCurveOffsets);
    listViews = {
      widget.navigationState.current.root.fullPath: _buildListView(context),
    };
  }

  @override
  void didUpdateWidget(DrawerSubList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final needsRebuild =
        listViews[widget.navigationState.current.root.fullPath] == null ||
            !setEquals(oldWidget.navigationState.expanded,
                widget.navigationState.expanded);
    if (needsRebuild) {
      listViews[widget.navigationState.current.root.fullPath] =
          _buildListView(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listView = listViews[widget.navigationState.current.root.fullPath]!;
    return widget.hasBackButton
        ? listView
        : AnimatedSwitcher(
            duration: widget.animationTheme.inlineDrawerSwitchDuration,
            switchInCurve: switchInCurve,
            switchOutCurve: switchOutCurve,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: listView,
          );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      key: ValueKey(widget.navigationState.current.root.fullPath),
      padding: EdgeInsets.only(top: widget.hasBackButton ? 0 : 12),
      children: [
        if (widget.hasBackButton)
          RailDrawerButton.back(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ..._buildChildren(
          hasBackButton: widget.hasBackButton,
          destinations: widget.navigationState.current.root.children,
          navigationState: widget.navigationState,
        ),
      ],
    );
  }

  List<Widget> _buildChildren({
    required bool hasBackButton,
    required List<Destination> destinations,
    required NavigationState navigationState,
    int level = 0,
  }) {
    return destinations
        .mapIndexed((index, destination) {
          final bool isExpandable = destination.children.isNotEmpty;
          final bool? isExpanded = isExpandable
              ? navigationState.expanded.contains(destination)
              : null;

          return <Widget>[
            DrawerItem(
              hasBackButton: hasBackButton,
              drawerItemIndent: widget.drawerItemIndent,
              index: index,
              destination: destination,
              level: level,
              isExpanded: isExpanded,
              isSelected: navigationState.current == destination,
              isRoot: false,
              onPressed: () => widget.onDestinationSelected(destination),
            ),
            if (isExpandable)
              DrawerSectionExpander(
                key: ValueKey(destination.fullPath),
                isExpanded: isExpanded!,
                animationTheme: widget.animationTheme,
                children: [
                  ..._buildChildren(
                    hasBackButton: hasBackButton,
                    destinations: destination.children,
                    navigationState: navigationState,
                    level: level + 1,
                  ),
                ],
              ),
          ];
        })
        .expand((widget) => widget)
        .toList();
  }
}
