import 'package:flutter/material.dart';
import '../models/DrawingArea.dart';
import '../utils/Constants.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingArea> points;
  List<Offset> offsetPoints = [];

  DrawingPainter(this.points);

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.black
    ..strokeWidth = Constants.strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      //Drawing line when two consecutive points are available
      canvas.drawLine(
          points[i].point, points[i + 1].point, points[i].areaPaint);
        }
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
