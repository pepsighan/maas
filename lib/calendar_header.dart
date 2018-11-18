import 'package:flutter/material.dart';
import 'package:maas/debug.dart';

class CalendarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    return ClipPath(
      child: Container(
        height: fullHeight * .45,
        color: Colors.grey,
      ),
      clipper: _BottomCurveClipper(),
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  final int _depth = 25;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - _depth);
    path.quadraticBezierTo(size.width / 4, size.height - _depth * 2,
        size.width / 2, size.height - _depth);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - _depth);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => isDebug;
}
