import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../material3/material3.dart';
import '../navigation/navigation.dart';
import 'material3_rail_drawer_scaffold.dart';

class Material3RailDrawerApp extends StatelessWidget {
  const Material3RailDrawerApp({
    super.key,
    required this.title,
    required this.destinations,
    this.animationTheme = const RailDrawerAnimationTheme(),
    this.appBar,
    this.drawerWidth,
    this.drawerItemIndent,
    this.drawerItemHeight,
    this.actions,
    this.builder,
    this.checkerboardOffscreenLayers = false,
    this.checkerboardRasterCacheImages = false,
    this.darkTheme,
    this.debugShowCheckedModeBanner = true,
    this.debugShowMaterialGrid = false,
    this.highContrastDarkTheme,
    this.highContrastTheme,
    this.locale,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.localizationsDelegates,
    this.onGenerateTitle,
    this.restorationScopeId,
    this.scaffoldMessengerKey,
    this.scrollBehavior,
    this.shortcuts,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.theme,
    this.themeAnimationCurve = Curves.easeInOutCubicEmphasized,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeMode = ThemeMode.system,
  });

  final AppBar? appBar;
  final List<Destination> destinations;
  final RailDrawerAnimationTheme animationTheme;
  final double? drawerWidth;
  final double? drawerItemIndent;
  final double? drawerItemHeight;
  final Map<Type, Action<Intent>>? actions;
  final TransitionBuilder? builder;
  final bool checkerboardOffscreenLayers;
  final bool checkerboardRasterCacheImages;
  final ThemeData? darkTheme;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final ThemeData? highContrastDarkTheme;
  final ThemeData? highContrastTheme;
  final Locale? locale;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final GenerateAppTitle? onGenerateTitle;
  final String? restorationScopeId;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final ScrollBehavior? scrollBehavior;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final Iterable<Locale> supportedLocales;
  final ThemeData? theme;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final ThemeMode themeMode;
  final String title;

  GoRoute buildRoute(Destination destination) {
    return GoRoute(
      path: destination.path,
      pageBuilder: (context, state) => MaterialPage(
          restorationId: destination.fullPath,
          child: destination.builder(context)),
      routes: [...destination.children.map((d) => buildRoute(d))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: restorationScopeId ?? 'root',
      title: title,
      themeMode: themeMode,
      routerConfig: GoRouter(
        restorationScopeId: 'router',
        initialLocation: '/',
        routes: [
          StatefulShellRoute.indexedStack(
            restorationScopeId: 'shell',
            pageBuilder: (context, state, navigationShell) {
              return MaterialPage(
                key: state.pageKey,
                restorationId: 'scaffold',
                child: Material3RailDrawerScaffold(
                  key: state.pageKey,
                  routerState: state,
                  title: title,
                  destinations: destinations,
                  animationTheme: animationTheme,
                  drawerWidth: drawerWidth,
                  drawerItemIndent: drawerItemIndent,
                  drawerItemHeight: drawerItemHeight,
                  navigationShell: navigationShell,
                  extendBodyBehindAppBar: false,
                  appBar: appBar,
                ),
              );
            },
            branches: [
              StatefulShellBranch(
                restorationScopeId: 'branch',
                routes: [
                  ...destinations.map((destination) => buildRoute(destination)),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: actions,
      builder: builder,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      debugShowMaterialGrid: debugShowMaterialGrid,
      highContrastDarkTheme: highContrastDarkTheme,
      highContrastTheme: highContrastTheme,
      locale: locale,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      localizationsDelegates: localizationsDelegates,
      onGenerateTitle: onGenerateTitle,
      scaffoldMessengerKey: scaffoldMessengerKey,
      scrollBehavior: scrollBehavior,
      shortcuts: shortcuts,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      supportedLocales: supportedLocales,
      theme: theme,
      themeAnimationCurve: themeAnimationCurve,
      themeAnimationDuration: themeAnimationDuration,
    );
  }
}
