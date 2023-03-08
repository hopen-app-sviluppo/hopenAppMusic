import 'dart:math';

import 'package:flutter/material.dart';

import '../types/types.dart';

class ShapeUtil {
  static double distance(Offset p1, Offset p2) {
    return sqrt(pow(p2.dy - p1.dy, 2) + pow(p2.dx - p1.dx, 2));
  }
}

typedef GestureCallback = void Function();

class TouchCanvasUtil {
  static Offset getPointFromGestureDetail(dynamic gestureDetail) {
    switch (gestureDetail.runtimeType) {
      case TapDownDetails:
        return (gestureDetail as TapDownDetails).localPosition;
      case TapUpDetails:
        return (gestureDetail as TapUpDetails).localPosition;
      case DragDownDetails:
        return (gestureDetail as DragDownDetails).localPosition;
      case DragStartDetails:
        return (gestureDetail as DragStartDetails).localPosition;
      case DragUpdateDetails:
        return (gestureDetail as DragUpdateDetails).localPosition;
      case LongPressStartDetails:
        return (gestureDetail as LongPressStartDetails).localPosition;
      case LongPressEndDetails:
        return (gestureDetail as LongPressEndDetails).localPosition;
      case LongPressMoveUpdateDetails:
        return (gestureDetail as LongPressMoveUpdateDetails).localPosition;
      case ScaleStartDetails:
        return (gestureDetail as ScaleStartDetails).localFocalPoint;
      case ScaleUpdateDetails:
        return (gestureDetail as ScaleUpdateDetails).localFocalPoint;
      case ForcePressDetails:
        return (gestureDetail as ForcePressDetails).localPosition;
      default:
        throw Exception(
            "gestureDetail.runTimeType = ${gestureDetail.runtimeType} is not recognized ! ");
    }
  }

  static Map<GestureType, Function> getGestureCallbackMap({
    required GestureTapDownCallback? onTapDown,
    required GestureTapUpCallback? onTapUp,
  }) {
    var map = <GestureType, Function>{};
    if (onTapDown != null) {
      map.putIfAbsent(GestureType.onTapDown, () => onTapDown);
    }
    if (onTapUp != null) map.putIfAbsent(GestureType.onTapUp, () => onTapUp);

    return map;
  }
}
