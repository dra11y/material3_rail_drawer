import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'destination.dart';
import 'navigation_state.dart';

class ToggleDrawerButton extends StatelessWidget {
  const ToggleDrawerButton({
    super.key,
    required this.isOpen,
    this.alignment = Alignment.centerLeft,
    required this.onPressed,
  });

  final bool isOpen;
  final Alignment alignment;
  final void Function(ScaffoldState)? onPressed;

  @override
  Widget build(BuildContext context) {
    final String drawerLabel = MaterialLocalizations.of(context).drawerLabel;
    return Builder(builder: (context) {
      return Align(
        alignment: alignment,
        child: IconButton(
          padding: const EdgeInsets.all(12),
          icon: Icon(
            isOpen ? Icons.menu_open : Icons.menu,
            semanticLabel: isOpen ? 'Close $drawerLabel' : 'Open $drawerLabel',
          ),
          onPressed: onPressed != null
              ? () => onPressed!.call(Scaffold.of(context))
              : null,
        ),
      );
    });
  }
}

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

class DrawerSubList extends StatefulWidget {
  const DrawerSubList({
    super.key,
    required this.hasBackButton,
    required this.drawerItemIndent,
    required this.navigationState,
    required this.onDestinationSelected,
  });

  final bool hasBackButton;
  final double drawerItemIndent;
  final NavigationState navigationState;
  final ValueChanged<Destination> onDestinationSelected;

  @override
  State<DrawerSubList> createState() => _DrawerSubListState();
}

class _DrawerSubListState extends State<DrawerSubList> {
  late ListView listView;

  @override
  void initState() {
    super.initState();
    listView = _buildListView(context);
  }

  @override
  void didUpdateWidget(DrawerSubList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newDestination = widget.navigationState.current;
    final needsRebuild =
        !newDestination.isRoot || newDestination.children.isNotEmpty;
    if (needsRebuild) {
      listView = _buildListView(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.hasBackButton
        ? listView
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: CatmullRomCurve.precompute(
                const [Offset(0.4, 0.0), Offset(0.95, 1.0)]),
            switchOutCurve: CatmullRomCurve.precompute(
                const [Offset(0.8, 0.0), Offset(0.95, 1.0)]),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: listView,
          );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      key: ValueKey(widget.navigationState.current.root.fullPath),
      padding: const EdgeInsets.only(top: 12),
      children: [
        if (widget.hasBackButton)
          DrawerButton.back(
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

          return [
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
                isExpanded: isExpanded!,
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

class DrawerSectionExpander extends HookWidget {
  const DrawerSectionExpander({
    super.key,
    required this.isExpanded,
    required this.children,
  });

  final bool isExpanded;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 300));
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    isExpanded ? controller.forward() : controller.reverse();
    return SizeTransition(
      axis: Axis.vertical,
      axisAlignment: -1,
      sizeFactor: animation,
      child: Column(
        children: children,
      ),
    );
  }
}

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
  Widget build(BuildContext context) => DrawerButton(
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

class DrawerButton extends StatefulWidget {
  const DrawerButton({
    super.key,
    required this.level,
    required this.drawerItemIndent,
    this.extraIndent = 0,
    this.index,
    required this.isSelected,
    this.isAccessibilityFocused = false,
    required this.icon,
    required this.selectedIcon,
    this.expanderIcon,
    required this.label,
    this.isExpanded,
    required this.onPressed,
    this.isSelectedBold = true,
  });

  final int level;
  final double drawerItemIndent;
  final double extraIndent;
  final int? index;
  final bool isSelected;
  final bool isAccessibilityFocused;
  final IconData icon;
  final IconData selectedIcon;
  final IconData? expanderIcon;
  final String label;
  final bool? isExpanded;
  final VoidCallback onPressed;
  final bool isSelectedBold;

  @override
  State<DrawerButton> createState() => _DrawerButtonState();

  factory DrawerButton.back({required VoidCallback onPressed}) => DrawerButton(
        level: 0,
        drawerItemIndent: 0,
        extraIndent: 0,
        isSelected: false,
        icon: Icons.arrow_back,
        selectedIcon: Icons.arrow_back,
        label: 'Main menu',
        onPressed: onPressed,
      );
}

class _DrawerButtonState extends State<DrawerButton> {
  bool needsTooltip = false;

  @override
  Widget build(BuildContext context) {
    final drawerTheme = NavigationDrawerTheme.of(context);
    final isMobileNative = [TargetPlatform.android, TargetPlatform.iOS]
        .contains(Theme.of(context).platform);
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = colorScheme.secondaryContainer;
    final foregroundColor = widget.isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    final double leftIndent =
        widget.extraIndent + widget.level * widget.drawerItemIndent;

    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: widget.isSelected && widget.isSelectedBold
              ? FontWeight.bold
              : null,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: drawerTheme.indicatorSize!.width - leftIndent,
            height: drawerTheme.tileHeight ?? drawerTheme.indicatorSize?.height,
            child: Semantics(
              container: true,
              button: true,
              selected: widget.isSelected,
              focused: widget.isAccessibilityFocused,
              excludeSemantics: true,
              label: [
                /// Semantics `selected` currently does not work outside of mobile native,
                /// so we must add it manually to the label in that case.
                if (widget.isSelected && !isMobileNative) 'selected',
                if (widget.isExpanded == false) 'collapsed',
                if (widget.isExpanded == true) 'expanded',
                widget.label,
              ].join(', '),
              child: Tooltip(
                excludeFromSemantics: true,
                message: needsTooltip ? widget.label : '',
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                        drawerTheme.indicatorShape is OutlinedBorder
                            ? drawerTheme.indicatorShape as OutlinedBorder
                            : const StadiumBorder()),
                    backgroundColor: MaterialStatePropertyAll(
                        widget.isSelected ? indicatorColor : null),
                    padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12)),
                  ),
                  icon: Icon(
                    widget.isSelected ? widget.selectedIcon : widget.icon,
                    color: foregroundColor,
                  ),
                  label: Row(
                    children: [
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        _enableTooltipIfNeeded(textStyle, context, constraints);
                        return Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle,
                        );
                      })),
                      if (widget.isExpanded != null)
                        Icon(
                          widget.expanderIcon ??
                              (widget.isExpanded == true
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                          color: foregroundColor,
                        ),
                    ],
                  ),
                  onPressed: () {
                    /// Dismiss the tooltip to prevent it from blocking VoiceOver.
                    Future.delayed(const Duration(milliseconds: 0), () {
                      Tooltip.dismissAllToolTips();
                    });
                    widget.onPressed();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _enableTooltipIfNeeded(
      TextStyle? textStyle, BuildContext context, BoxConstraints constraints) {
    if (needsTooltip) return;

    final textSpan = TextSpan(
      text: widget.label,
      style: textStyle,
    );
    final textPainter = TextPainter(
      maxLines: 1,
      text: textSpan,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: constraints.maxWidth);
    if (textPainter.didExceedMaxLines) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          needsTooltip = true;
        });
      });
    }
  }
}
