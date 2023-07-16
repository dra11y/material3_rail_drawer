import 'package:flutter/material.dart';

class Destination {
  Destination({
    this.isRoute = true,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
    required this.fullPath,
    required this.builder,
  });

  final bool isRoute;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
  final String fullPath;
  final WidgetBuilder builder;

  late final List<Destination> children;
  late final Destination? parent;
  late final Destination root;
  late final List<Destination> ancestors;

  bool get isRoot => this == root;

  @override
  int get hashCode => fullPath.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Destination && other.fullPath == fullPath;

  @override
  String toString() => '''\n    Destination(
      fullPath: $fullPath,
      isRoute: $isRoute,
      label: $label
    )''';
}
