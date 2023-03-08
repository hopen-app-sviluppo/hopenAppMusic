import 'package:flutter/material.dart';
import '../../theme.dart';

//* metodo per disegnarli
Widget drawLines(BuildContext context, {bool isTopDraw = true}) => ClipPath(
      clipper: isTopDraw ? CustomTopClipper() : CustomBottomClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            MainColor.secondaryColor,
            MainColor.secondaryAccentColor,
          ]),
        ),
      ),
    );

//* rappresentano i disegni ondine verdi

class CustomTopClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height * 0.325);

    final firstEndpoint = Offset(size.width * 0.22, size.height * 0.2);
    final firstControlPoint = Offset(size.width * 0.125, size.height * 0.30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy);

    final secondEndpoint = Offset(size.width * 0.6, size.height * 0.0725);
    final secondControlPoint = Offset(size.width * 0.3, size.height * 0.0825);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndpoint.dx, secondEndpoint.dy);

    final thirdEndpoint = Offset(size.width, size.height * 0.0);
    final thirdControlPoint = Offset(size.width * 0.99, size.height * 0.05);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndpoint.dx, thirdEndpoint.dy);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    path.moveTo(size.width * 0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.675);

    final firstEndpoint = Offset(size.width * 0.78, size.height * 0.8);
    final firstControlPoint = Offset(size.width * 0.875, size.height * 0.70);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy);

    final secondEndpoint = Offset(size.width * 0.30, size.height * 0.9275);
    final secondControlPoint = Offset(size.width * 0.70, size.height * 0.8975);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndpoint.dx, secondEndpoint.dy);

    final thirdEndpoint = Offset(size.width * 0.0, size.height);
    final thirdControlPoint = Offset(size.width * 0.04, size.height * 0.95);

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndpoint.dx, thirdEndpoint.dy);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
