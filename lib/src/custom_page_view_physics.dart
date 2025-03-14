import 'package:flutter/widgets.dart';

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  double get dragStartDistanceMotionThreshold => 10;

  @override
  SpringDescription get spring {
    return const SpringDescription(
      mass: 8,
      stiffness: 150,
      damping: 15,
    );
  }
}
