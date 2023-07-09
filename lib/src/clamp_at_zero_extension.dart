extension IntExtension on int {
  int get clampAtZero => this >= 0 ? this : 0;
}
