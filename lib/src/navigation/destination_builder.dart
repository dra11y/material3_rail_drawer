import 'package:flutter/material.dart';

import 'destination.dart';

class DestinationBuilder {
  DestinationBuilder({
    this.isRoute = true,
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.path,
    required this.builder,
    this.children = const [],
  }) : assert(children.isEmpty || isRoute == false,
            'Expandable destinations should not be routed.');

  final bool isRoute;
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String path;
  final WidgetBuilder builder;
  final List<DestinationBuilder> children;

  Destination build({
    Destination? root,
    Destination? parent,
    String? fullPath,
  }) {
    final newPath = [
      fullPath,
      path,
    ].whereType<String>().join('/');

    final Destination destination = Destination(
      isRoute: isRoute,
      label: label,
      icon: icon,
      selectedIcon: selectedIcon ?? icon,
      path: path,
      fullPath: newPath,
      builder: builder,
    );

    destination.parent = parent;
    destination.root = root ?? destination;
    destination.ancestors = [
      for (Destination? d = destination.parent; d != null; d = d.parent) d
    ];

    destination.children = children
        .map((builder) => builder.build(
              root: destination.root,
              parent: destination,
              fullPath: newPath,
            ))
        .toList();

    return destination;
  }
}
