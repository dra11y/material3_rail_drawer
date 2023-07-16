/// https://developer.android.com/guide/topics/large-screens/support-different-screen-sizes#window_size_classes

enum WindowSize {
  compact,
  medium,
  expanded;

  static WindowSize fromWidth(double width) =>
      width < 600 ? compact : (width < 840 ? medium : expanded);

  static WindowSize fromHeight(double height) =>
      height < 480 ? compact : (height < 900 ? medium : expanded);

  bool get isCompact => this == compact;
  bool get isCompactOrMedium => !isExpanded;
  bool get isMedium => this == medium;
  bool get isMediumOrExpanded => !isCompact;
  bool get isExpanded => this == expanded;
}
