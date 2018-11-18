import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: FractionallySizedBox(
        child: Container(
          color: Colors.grey,
        ),
        heightFactor: .45,
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
