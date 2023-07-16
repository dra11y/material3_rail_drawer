import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../material3/material3.dart';
import '../navigation/navigation.dart';
import 'drawer/drawer.dart';
import 'material3_rail_drawer_shell.dart';
import 'window_size_changed_detector.dart';

class Material3RailDrawerScaffold extends StatefulWidget {
  const Material3RailDrawerScaffold({
    super.key,
    required this.title,
    required this.routerState,
    required this.destinations,
    required this.animationTheme,
    required this.navigationShell,
    this.drawerWidth,
    this.drawerItemIndent,
    this.drawerItemHeight,
    this.appBar,
    this.bottomSheet,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.onDrawerChanged,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.resizeToAvoidBottomInset,
    this.restorationId,
  });

  final GoRouterState routerState;
  final String title;
  final List<Destination> destinations;
  final RailDrawerAnimationTheme animationTheme;
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget? appBar;
  final Widget? bottomSheet;
  final double? drawerWidth;
  final double? drawerItemIndent;
  final double? drawerItemHeight;
  final bool extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final DrawerCallback? onDrawerChanged;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool? resizeToAvoidBottomInset;
  final String? restorationId;

  @override
  State<Material3RailDrawerScaffold> createState() =>
      _Material3RailDrawerScaffoldState();
}

class _Material3RailDrawerScaffoldState
    extends State<Material3RailDrawerScaffold> {
  late WindowSize windowSize =
      WindowSize.fromWidth(MediaQuery.sizeOf(context).width);
  late NavigationState navigationState =
      NavigationState.initial(destinations: widget.destinations);
  late bool isDrawerOpen = windowSize.isMediumOrExpanded &&
      navigationState.current.root.children.isNotEmpty;

  void _onDestinationSelected(Destination destination) {
    setState(() {
      navigationState = navigationState.select(destination);
      isDrawerOpen = navigationState.current.root.children.isNotEmpty;
    });
    if (!destination.isRoute) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final extra = jsonEncode(navigationState);
      context.go(destination.fullPath, extra: extra);
    });
  }

  @override
  void didUpdateWidget(covariant Material3RailDrawerScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final fullPath = widget.routerState.fullPath;
    if (fullPath == null) return;
    if (widget.routerState.extra != null) {
      final Map extra = jsonDecode(widget.routerState.extra.toString());
      navigationState = navigationState.updateWithJson(extra);
      return;
    }
    final destination = navigationState.findDestination(fullPath);
    if (destination != null) {
      navigationState = navigationState.select(destination);
    }
  }

  void _onTapDrawerToggleButton(ScaffoldState scaffold) {
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
      // We update `isDrawerOpen` in the `onDrawerChanged` callback.
      return;
    }

    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  Widget _buildNavigationDrawer() => Material3RailDrawerDrawer(
        key: ValueKey(windowSize),
        windowSize: windowSize,
        animationTheme: widget.animationTheme,
        drawerItemIndent: widget.drawerItemIndent ?? 12.0,
        navigationState: navigationState,
        onDestinationSelected: _onDestinationSelected,
        onTapDrawerToggleButton: _onTapDrawerToggleButton,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final drawerTheme = DrawerTheme.of(context);
    final navigationDrawerTheme = NavigationDrawerTheme.of(context);
    final railTheme = NavigationRailTheme.of(context);

    final drawerWidth =
        widget.drawerWidth ?? drawerTheme.width ?? 360.0; // Material 3 spec
    final defaultIndicatorWidth = drawerWidth - 24.0;
    const defaultIndicatorHeight = 56.0; // Material 3 spec

    return Theme(
      data: Theme.of(context).copyWith(
        drawerTheme: drawerTheme.copyWith(
          backgroundColor: drawerTheme.backgroundColor ?? colorScheme.surface,
          elevation: navigationDrawerTheme.elevation ?? 1.0,
          width: drawerWidth, // Material 3 spec
        ),
        navigationDrawerTheme: navigationDrawerTheme.copyWith(
          backgroundColor: navigationDrawerTheme.backgroundColor ??
              drawerTheme.backgroundColor ??
              colorScheme.surface,
          elevation: navigationDrawerTheme.elevation ??
              (windowSize.isCompact ? 1.0 : 0.0),
          tileHeight: widget.drawerItemHeight ??
              navigationDrawerTheme.tileHeight ??
              defaultIndicatorHeight,
          indicatorShape:
              navigationDrawerTheme.indicatorShape ?? const StadiumBorder(),
          indicatorSize: navigationDrawerTheme.indicatorSize ??
              Size(defaultIndicatorWidth, defaultIndicatorHeight),
        ),
        navigationRailTheme: railTheme.copyWith(
          backgroundColor: railTheme.backgroundColor ?? colorScheme.surface,
          elevation: railTheme.elevation ?? 0.0,
          groupAlignment: railTheme.groupAlignment ?? -1,
          labelType: railTheme.labelType ?? NavigationRailLabelType.all,
          useIndicator: railTheme.useIndicator ?? true,
          minWidth: railTheme.minWidth ?? 80.0, // Material 3 spec
          minExtendedWidth: railTheme.minExtendedWidth ?? 256,
        ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            WindowSizeChangedDetector(
              windowSize: windowSize,
              onChanged: (type) {
                setState(() {
                  windowSize = type;
                });
              },
            ),
            Material3RailDrawerShell(
              windowSize: windowSize,
              isDrawerOpen: isDrawerOpen,
              navigationState: navigationState,
              animationTheme: widget.animationTheme,
              navigationShell: widget.navigationShell,
              inlineNavigationDrawer:
                  windowSize.isCompact ? null : _buildNavigationDrawer(),
              onDestinationSelected: _onDestinationSelected,
              onTapDrawerToggleButton: _onTapDrawerToggleButton,
            ),
          ],
        ),
        drawer: windowSize.isCompact
            ? BlockSemantics(
                child: _buildNavigationDrawer(),
              )
            : null,
        appBar: windowSize.isCompact
            ? (widget.appBar ??
                AppBar(
                  forceMaterialTransparency: true,
                  title: Text(navigationState.current.label),
                ))
            : null,
        bottomSheet: widget.bottomSheet,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        onDrawerChanged: (isOpened) {
          isDrawerOpen = isOpened;
          widget.onDrawerChanged?.call(isOpened);
        },
        persistentFooterButtons: widget.persistentFooterButtons,
        persistentFooterAlignment: widget.persistentFooterAlignment,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        restorationId: widget.restorationId,
      ),
    );
  }
}
