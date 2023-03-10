import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' hide Image;

import '../touchable.dart';
import 'shape_handler.dart';
import 'shapes/arc.dart';
import 'shapes/circle.dart';
import 'shapes/clip.dart';
import 'shapes/line.dart';
import 'shapes/oval.dart';
import 'shapes/path.dart';
import 'shapes/point.dart';
import 'shapes/rectangle.dart';
import 'shapes/rounded_rectangle.dart';
import 'shapes/util.dart';

class TouchyCanvas {
  final Canvas _canvas;

  final ShapeHandler _shapeHandler = ShapeHandler();

  ///[TouchyCanvas] helps you add gesture callbacks to the shapes you draw.
  ///
  /// [context] is the BuildContext that is obtained from the [CanvasTouchDetector] widget's builder function.
  /// The parameter [canvas] is the [Canvas] object that you get in your [paint] method inside [CustomPainter]
  TouchyCanvas(
    BuildContext context,
    this._canvas, {
    ScrollController? scrollController,
    AxisDirection scrollDirection = AxisDirection.down,
  }) {
    var touchController = TouchDetectionController.of(context);
    touchController?.addListener((event) {
      _shapeHandler.handleGestureEvent(
        event,
        scrollController: scrollController,
        direction: scrollDirection,
      );
    });
  }

  void clipPath(Path path, {bool doAntiAlias = true}) {
    _canvas.clipPath(path, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipPathShape(path));
  }

  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {
    _canvas.clipRRect(rrect, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipRRectShape(rrect));
  }

  void clipRect(Rect rect,
      {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {
    _canvas.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipRectShape(rect, clipOp: clipOp));
  }

  void drawCircle(
    Offset c,
    double radius,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawCircle(c, radius, paint);
    _shapeHandler.addShape(Circle(
        center: c,
        radius: radius,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawLine(
    Offset p1,
    Offset p2,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawLine(p1, p2, paint);
    _shapeHandler.addShape(Line(p1, p2,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawOval(
    Rect rect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawOval(rect, paint);
    _shapeHandler.addShape(Oval(rect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawParagraph(Paragraph paragraph, Offset offset) {
    _canvas.drawParagraph(paragraph, offset);
    // _shapeHandler.addShape(Rectangle(Rect.fromLTWH(offset.dx, offset.dy, paragraph.width, paragraph.height),
    //     paint: Paint(), gestureMap: {}));
  }

  void drawPath(
    Path path,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawPath(path, paint);
    _shapeHandler.addShape(PathShape(path,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawPoints(
    PointMode pointMode,
    List<Offset> points,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawPoints(pointMode, points, paint);
    _shapeHandler.addShape(Point(pointMode, points,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawRRect(
    RRect rrect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawRRect(rrect, paint);
    _shapeHandler.addShape(RoundedRectangle(rrect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawRawPoints(
    PointMode pointMode,
    Float32List points,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawRawPoints(pointMode, points, paint);
    List<Offset> offsetPoints = [];
    for (int i = 0; i < points.length; i += 2) {
      offsetPoints.add(Offset(points[i], points[i + 1]));
    }
    _shapeHandler.addShape(Point(pointMode, offsetPoints,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawRect(
    Rect rect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawRect(rect, paint);
    _shapeHandler.addShape(Rectangle(rect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawShadow(
      Path path, Color color, double elevation, bool transparentOccluder) {
    _canvas.drawShadow(path, color, elevation, transparentOccluder);
    // _shapeHandler.addShape(PathShape(path));
  }

  void drawImage(
    Image image,
    Offset p,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawImage(image, p, paint);
    _shapeHandler.addShape(Rectangle(
        Rect.fromLTWH(
            p.dx, p.dy, image.width.toDouble(), image.height.toDouble()),
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        )));
  }

  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
  }) {
    _canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    var arc = Arc(rect, startAngle, sweepAngle, useCenter,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
        ));
    _shapeHandler.addShape(arc);
  }

//
//  void drawDRRect(RRect outer, RRect inner, Paint paint) {
//    _canvas.drawDRRect(outer, inner, paint);
//    // TODO: implement drawDRRect in SHapeHandler
//  }
//
//
//  void drawRawAtlas(Image atlas, Float32List rstTransforms, Float32List rects,
//      Int32List colors, BlendMode blendMode, Rect cullRect, Paint paint) {
//    // TODO: implement drawRatAtlas
//    _canvas.drawRawAtlas(atlas, rstTransforms, rects, colors, blendMode, cullRect, paint);
//  }
//
//  void drawImageNine(Image image, Rect center, Rect dst, Paint paint){
//    // TODO: implement drawImageNine
//    _canvas.drawImageNine(image, center, dst, paint);
//  }
//
//  void drawImageRect(Image image, Rect src, Rect dst, Paint paint){
//    // TODO: implement drawImageRect
//    _canvas.drawImageRect(image, src, dst, paint);
//  }
//
//  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {
//    _canvas.drawVertices(vertices, blendMode, paint);
// TODO: implement drawVertices
//  }

//
//  void rotate(double radians) {
//    // TODO: implement rotate
//  }

//
//  void scale(double sx, [double sy]) {
//    // TODO: implement scale
//  }

//
//  void skew(double sx, double sy) {
//    // TODO: implement skew
//  }

//
//  void transform(Float64List matrix4) {
//    // TODO: implement transform
//  }

//
//  void translate(double dx, double dy) {
//   _canvas.translate(dx, dy);
//    // TODO: implement translate
//  }

//
//  void drawAtlas(Image atlas, List<RSTransform> transforms, List<Rect> rects,
//      List<Color> colors, BlendMode blendMode, Rect cullRect, Paint paint) {
//    // TODO: implement drawAtlas
//  }
//    _canvas.drawAtlas(atlas, transforms, rects, colors, blendMode, cullRect, paint);
//  }
}
