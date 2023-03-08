import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  final void Function() onTimerEnds;
  final double score;
  final Color color;
  final String fieldName;
  const CustomTooltip({
    Key? key,
    required this.onTimerEnds,
    required this.score,
    required this.color,
    required this.fieldName,
  }) : super(key: key);

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        "${widget.fieldName}:\n${widget.score.toStringAsFixed(2)}%",
        textAlign: TextAlign.start,
      ),
    );
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    widget.onTimerEnds();
  }
}
