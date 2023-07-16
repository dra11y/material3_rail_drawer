import 'package:flutter/material.dart';

import 'material3.dart';

class RailDrawerAnimationTheme {
  const RailDrawerAnimationTheme({
    this.inlineDrawerOpenCloseDuration =
        AnimationDurations.emphasizedDecelerate,
    this.inlineDrawerOpenCloseCurve = AnimationCurves.emphasizedDecelerate,
    this.inlineDrawerSwitchDuration = AnimationDurations.emphasizedDecelerate,
    this.inlineDrawerSwitchInCurveOffsets = const [
      Offset(0.4, 0.0),
      Offset(0.95, 1.0),
    ],
    this.inlineDrawerSwitchOutCurveOffsets = const [
      Offset(0.8, 0.0),
      Offset(0.95, 1.0),
    ],
    this.expandCollapseItemDuration = AnimationDurations.standardDecelerate,
    this.expandCollapseItemCurve = AnimationCurves.linear,
  });

  final Duration inlineDrawerOpenCloseDuration;
  final Curve inlineDrawerOpenCloseCurve;
  final Duration inlineDrawerSwitchDuration;
  final List<Offset> inlineDrawerSwitchInCurveOffsets;
  final List<Offset> inlineDrawerSwitchOutCurveOffsets;
  final Duration expandCollapseItemDuration;
  final Curve expandCollapseItemCurve;
}
