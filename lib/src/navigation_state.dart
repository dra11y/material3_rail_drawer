import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'destination.dart';

@immutable
class NavigationState {
  const NavigationState({
    required this.destinations,
    required this.current,
    this.previous,
    required this.expanded,
  });

  final List<Destination> destinations;
  final Destination current;
  final Destination? previous;
  final Set<Destination> expanded;

  static NavigationState initial({required List<Destination> destinations}) =>
      NavigationState(
        destinations: destinations,
        current: destinations.first,
        expanded: const {},
      );

  NavigationState select(Destination destination) {
    final shouldChange = destination.isRoute || destination.isRoot;
    return NavigationState(
      destinations: destinations,
      current: shouldChange ? destination : current,
      previous: shouldChange ? current : previous,
      expanded: {
        ...expanded.whereNot((d) => d == destination),
        ...destination.ancestors,
        if (destination.children.isNotEmpty && !expanded.contains(destination))
          destination,
      },
    );
  }

  @override
  int get hashCode => Object.hashAllUnordered([
        current,
        ...destinations,
        ...expanded,
      ]);

  Destination? findDestination(String fullPath,
      [List<Destination>? destinations]) {
    destinations ??= this.destinations;
    for (final destination in destinations) {
      if (destination.fullPath == fullPath) {
        return destination;
      }
      final child = findDestination(fullPath, destination.children);
      if (child != null) {
        return child;
      }
    }
    return null;
  }

  NavigationState updateWithJson(Map json) {
    return NavigationState(
      destinations: destinations,
      current: findDestination(json['selectedDestination'])!,
      previous: current,
      expanded: {
        ...json['expandedDestinations']
            .map((fullPath) => findDestination(fullPath))
            .whereType<Destination>(),
      },
    );
  }

  Map toJson() => {
        'selectedDestination': current.fullPath,
        'expandedDestinations': expanded.map((d) => d.fullPath).toList(),
      };

  @override
  bool operator ==(Object other) {
    return other is NavigationState &&
        current == other.current &&
        listEquals(destinations, other.destinations) &&
        setEquals(expanded, other.expanded);
  }

  @override
  String toString() =>
      'NavigationState(selectedDestination: $current, expandedDestinations: $expanded)';
}
