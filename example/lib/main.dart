import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material3_rail_drawer/material3_rail_drawer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();

  runApp(const RailDrawerExampleApp());
}

final List<Destination> destinations = [
  DestinationBuilder(
    label: 'Home',
    icon: Icons.home,
    path: '/',
    builder: (context) => Text(
        key: ValueKey(Theme.of(context).brightness),
        '${Theme.of(context).brightness}'),
  ),
  DestinationBuilder(
    isRoute: false,
    label: 'Categories',
    icon: Icons.category,
    path: '/categories',
    builder: (context) => const Text('categories page'),
    children: [
      DestinationBuilder(
        label: 'Foo',
        icon: Icons.fort,
        path: 'foo',
        isRoute: false,
        builder: (context) => const Text('foo category'),
        children: [
          DestinationBuilder(
            label: 'Item 1',
            icon: Icons.airplanemode_active,
            path: 'item-1',
            builder: (context) => const Text('item one'),
          ),
          DestinationBuilder(
            label: 'Item 2',
            icon: Icons.abc,
            path: 'item-2',
            isRoute: false,
            builder: (context) => const Text('item two'),
            children: [
              DestinationBuilder(
                label: 'Subitem A with a long title',
                icon: Icons.abc,
                path: 'subitem-A',
                builder: (context) => const Text('subitem A'),
              ),
              DestinationBuilder(
                label: 'Subitem B',
                icon: Icons.abc,
                path: 'subitem-B',
                builder: (context) => const Text('subitem B'),
              ),
            ],
          ),
          DestinationBuilder(
            label: 'Item 3',
            icon: Icons.store,
            path: 'item-3',
            builder: (context) => const Text('item three'),
          ),
        ],
      ),
      DestinationBuilder(
        label: 'Bar',
        icon: Icons.bar_chart,
        path: 'bar',
        builder: (context) => const Text('bar category'),
      ),
      DestinationBuilder(
        label: 'Baz',
        icon: Icons.sports_baseball,
        path: 'baz',
        builder: (context) => const Text('baz category'),
      ),
    ],
  ),
  DestinationBuilder(
    label: 'Admin',
    icon: Icons.admin_panel_settings,
    path: '/admin',
    isRoute: false,
    builder: (context) => const Text('admin page'),
    children: [
      DestinationBuilder(
        label: 'Users',
        icon: Icons.people,
        path: 'users',
        builder: (context) => const Text('users admin'),
      ),
      DestinationBuilder(
        label: 'Things',
        icon: Icons.widgets,
        path: 'things',
        builder: (context) => const Text('things admin'),
      ),
    ],
  ),
].map((builder) => builder.build()).toList();

class RailDrawerExampleApp extends StatelessWidget {
  const RailDrawerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material3RailDrawerApp(
      debugShowCheckedModeBanner: false,
      title: 'Material3 Rail Drawer Demo',
      destinations: destinations,
      drawerWidth: 230,
      drawerItemIndent: 12,
      drawerItemHeight: 48,
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
