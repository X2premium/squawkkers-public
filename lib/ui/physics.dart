import 'package:flutter/material.dart';

/// The default PageView scroll physics are very sensitive, and easily swipe pages when you mean to scroll up and down
/// instead. This raises the gesture threshold while keeping stable, non-oscillating defaults.
class LessSensitiveScrollPhysics extends ScrollPhysics {
  const LessSensitiveScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  LessSensitiveScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LessSensitiveScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 24;

  @override
  double get minFlingDistance => 24;

  @override
  double get minFlingVelocity => 320;
}
