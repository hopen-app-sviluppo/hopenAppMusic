import 'package:flutter/cupertino.dart';

import '../types/types.dart';
import 'shape.dart';

class Rectangle extends Shape {
  final Rect rect;

  Rectangle(this.rect,
      {Map<GestureType, Function>? gestureMap,
      Paint? paint,
      HitTestBehavior? hitTestBehavior,
      PaintingStyle? paintStyleForTouch})
      : super(
            hitTestBehavior: hitTestBehavior,
            paint: paint ?? Paint(),
            gestureCallbackMap: gestureMap ?? {});

  @override
  bool isInside(Offset p) {
    if (paint.style == PaintingStyle.fill) {
      return rect.contains(p);
    } else {
      double extraWidth = paint.strokeWidth / 2;

      bool insideOuterRect = Rect.fromLTRB(
              rect.left - extraWidth,
              rect.top - extraWidth,
              rect.right + extraWidth,
              rect.bottom + extraWidth)
          .contains(p);

      bool outsideInnerRect = !Rect.fromLTRB(
              rect.left + extraWidth,
              rect.top + extraWidth,
              rect.right - extraWidth,
              rect.bottom - extraWidth)
          .contains(p);
      return insideOuterRect && outsideInnerRect;
    }
  }
}
