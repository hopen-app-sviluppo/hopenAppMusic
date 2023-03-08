import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;
import '../helpers/grafici_client_provider.dart';
import 'custom_touchable/src/custom_tooltip.dart';
import 'custom_touchable/touchable.dart';

//* codice preso dalla libreria flutter_radar_chart

class CustomRadarChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<List<double?>> data;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;

  const CustomRadarChart({
    Key? key,
    required this.ticks,
    required this.features,
    required this.data,
    this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.featuresTextStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    this.graphColors = defaultGraphColors,
    this.sides = 0,
  }) : super(key: key);

  @override
  _CustomRadarChartState createState() => _CustomRadarChartState();
}

class _CustomRadarChartState extends State<CustomRadarChart>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController animationController;
  double top = 0.0;
  double left = 0.0;
  double currentScore = 0.0;
  bool show = false;
  Color? color;
  String? field;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    animationController.forward();
  }

  @override
  void didUpdateWidget(CustomRadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CanvasTouchDetector(
        builder: (ctx) => CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: RadarChartPainter(
              widget.ticks,
              widget.features,
              widget.data,
              widget.ticksTextStyle,
              widget.featuresTextStyle,
              widget.outlineColor,
              widget.axisColor,
              widget.graphColors,
              widget.sides,
              fraction,
              ctx, (score, position, colors, fieldName) {
            setState(() {
              top = position.dy;
              left = position.dx;
              currentScore = score;
              color = colors;
              field = fieldName;
              show = true;
            });
          }),
        ),
      ),
      if (show)
        Positioned(
          top: top,
          left: left,
          child: CustomTooltip(
            score: currentScore,
            color: color ?? Colors.transparent,
            fieldName: field ?? "",
            onTimerEnds: () {
              setState(() {
                show = false;
              });
            },
          ),
        ),
    ]);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<List<double?>> data;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double fraction;
  final BuildContext context;
  final Function(double, Offset, Color color, String field) onItemTapped;
  Path path;

  RadarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.graphColors,
    this.sides,
    this.fraction,
    this.context,
    this.onItemTapped,
  ) : path = Path();

  Path variablePath(Size size, double radius, int sides) {
    //! path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    if (sides < 3) {
      // Draw a circle
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));
    } else {
      // Draw a polygon
      Offset startPoint = Offset(radius * cos(-pi / 2), radius * sin(-pi / 2));

      path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      for (int i = 1; i <= sides; i++) {
        double x = radius * cos(angle * i - pi / 2) + center.dx;
        double y = radius * sin(angle * i - pi / 2) + center.dy;
        path.lineTo(x, y);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY) * 0.7;
    final scale = radius / ticks.last;
    final myCanvas = TouchyCanvas(context, canvas);

    // Painting the chart outline
    var outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    var ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    canvas.drawPath(variablePath(size, radius, sides), outlinePaint);
    // Painting the circles and labels for the given ticks (could be auto-generated)
    // The last tick is ignored, since it overlaps with the feature label
    var tickDistance = radius / (ticks.length - 1);

//testo al centro del grafico >(in questo caso è 0 (primo valore passato come ticks))
    TextPainter(
      text: TextSpan(text: " ${ticks[0]}%", style: ticksTextStyle),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: size.width)
      ..paint(canvas, Offset(centerX, centerY - ticksTextStyle.fontSize!));

//linee dentro il grafico, per ogni ticks disegno una linea
    ticks.sublist(1, ticks.length).asMap().forEach((index, tick) {
      var tickRadius = tickDistance * (index + 1);

      canvas.drawPath(variablePath(size, tickRadius, sides), ticksPaint);
      TextPainter(
        text: TextSpan(text: "$tick%", style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas,
            Offset(centerX, centerY - tickRadius - ticksTextStyle.fontSize!));
    });

    // Painting the axis for each given feature
    var angle = (2 * pi) / features.length;

//per ogni feature ("emotivo","dentro...."")
    features.asMap().forEach((index, feature) {
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);

      var featureOffset =
          Offset(centerX + radius * xAngle, centerY + radius * yAngle);

      canvas.drawLine(centerOffset, featureOffset, ticksPaint);

      var featureLabelFontHeight = index != 0
          ? featuresTextStyle.fontSize
          : featuresTextStyle.fontSize! * 2;
      var labelYOffset = yAngle < 0 ? -featureLabelFontHeight! : 0;
      var labelXOffset = xAngle > 0 ? featureOffset.dx : 0.0;

      TextPainter(
        text: TextSpan(text: feature, style: featuresTextStyle),
        textAlign: xAngle < 0 ? TextAlign.right : TextAlign.left,
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: featureOffset.dx)
        ..paint(canvas, Offset(labelXOffset, featureOffset.dy + labelYOffset));
    });

    // Painting each graph
    data.asMap().forEach((index1, graph) {
      final currentColor = graphColors[index1 % graphColors.length];
      var graphPaint = Paint()
        ..color = currentColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      var graphOutlinePaint = Paint()
        ..color = currentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      var circlePaint = Paint()
        ..color = currentColor
        ..style = PaintingStyle.fill;

      // Start the graph on the initial point
      double scaledPoint = scale * graph[0]! * fraction;
      path = Path();

      path.moveTo(centerX, centerY - scaledPoint);

      graph.asMap().forEach((index2, point) {
        //if (index == 0) return;

        var xAngle = cos(angle * index2 - pi / 2);
        var yAngle = sin(angle * index2 - pi / 2);
        var scaledPoint = scale * point! * fraction;

        path.lineTo(
            centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        //pallini sui risultati
        //TODO: SE CI CLICCO APPARE => DENTRO: VALORE
        myCanvas.drawCircle(
            Offset(
              centerX + scaledPoint * xAngle,
              centerY + scaledPoint * yAngle,
            ),
            math.min(centerX, centerY) * 0.04,
            circlePaint, onTapUp: (TapUpDetails details) {
          //print("punteggio: $point e pos: ${details.localPosition}");
          onItemTapped(
            point,
            details.localPosition,
            currentColor,
            features[index2],
          );
        });
      });

      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
