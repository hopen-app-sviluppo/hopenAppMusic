import 'package:flutter/material.dart';
import 'package:music/responsive_widget/responsive_widget.dart';
import 'package:music/router.dart';
import 'package:music/theme.dart';

class FloatingActBtn extends StatefulWidget {
  const FloatingActBtn({Key? key}) : super(key: key);

  @override
  State<FloatingActBtn> createState() => _FloatingActBtnState();
}

class _FloatingActBtnState extends State<FloatingActBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    //size dell'icona del floating action button, non facile da definire
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.4,
        upperBound: 1.0);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ResponsiveWidget(
        mobileWidget: _buildMobileFab(),
        tabletWidget: _buildTabletFab(),
        webWidget: _buildWebFab(),
      );

  Widget _buildMobileFab() => SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        child: _buildFab(),
      );

  Widget _buildTabletFab() => SizedBox(
        width: MediaQuery.of(context).size.width * 0.09,
        height: MediaQuery.of(context).size.width * 0.09,
        child: _buildFab(),
      );

  Widget _buildWebFab() => SizedBox(
        width: MediaQuery.of(context).size.width * 0.05,
        height: MediaQuery.of(context).size.width * 0.05,
        child: _buildFab(),
      );

  FloatingActionButton _buildFab() => FloatingActionButton(
        elevation: 10.0,
        backgroundColor: MainColor.secondaryAccentColor,
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRouter.feedbackPage),
        child: FadeTransition(
          opacity: _animationController,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: MainColor.primaryColor,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.feedback_outlined,
              color: Colors.white,
              size: getIconSize(),
            ),
          ),
        ),
      );

  double getIconSize() => MediaQuery.of(context).size.width > 1200
      ? MediaQuery.of(context).size.width * 0.02
      : MediaQuery.of(context).size.width * 0.05;
}
