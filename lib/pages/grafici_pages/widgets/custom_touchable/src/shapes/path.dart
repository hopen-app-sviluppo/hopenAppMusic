import 'package:flutter/material.dart';

import '../types/types.dart';
import 'shape.dart';

class PathShape extends Shape {
  final Path path;

  PathShape(this.path,
      {required Map<GestureType, Function> gestureMap,
      required Paint paint,
      HitTestBehavior? hitTestBehavior,
      PaintingStyle? paintStyleForTouch})
      : super(
            hitTestBehavior: hitTestBehavior,
            paint: paint,
            gestureCallbackMap: gestureMap);

  @override
  bool isInside(Offset p) {
    return path.contains(p);
  }
}
