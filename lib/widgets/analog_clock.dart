import 'dart:math' as math;

import 'package:baharudin_alarm/utils/extensions/date_time.dart';
import 'package:flutter/material.dart';

class AnalogClock extends StatelessWidget {
  final double diagonal;
  final DateTime time;

  const AnalogClock({
    Key? key,
    required this.diagonal,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size.square(diagonal),
      painter: _ClockBackgroundPainter(
        backgroundColor: colorScheme.primaryContainer,
        hourColor: colorScheme.primary,
        dashColor: colorScheme.onPrimaryContainer,
        outlineColor: colorScheme.inversePrimary,
      ),
      foregroundPainter: _MainPainter(
        backgroundColor: colorScheme.background,
        hourDash: Dash(
            length: 0.45, color: colorScheme.onSecondaryContainer, width: 9),
        minuteDash: Dash(
            length: 0.6, color: colorScheme.onSecondaryContainer, width: 5),
        secondDash: Dash(length: 0.75, color: colorScheme.primary, width: 2.5),
        time: time,
      ),
    );
  }
}

class _ClockBackgroundPainter extends CustomPainter {
  final Color backgroundColor;
  final Color hourColor;
  final Color dashColor;
  final Color outlineColor;

  _ClockBackgroundPainter({
    required this.backgroundColor,
    required this.hourColor,
    required this.dashColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    final backgroundPaint = Paint()..color = backgroundColor;
    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;

    canvas.translate(radius, radius);
    canvas.drawCircle(Offset.zero, radius, backgroundPaint);
    canvas.drawCircle(Offset.zero, radius, outlinePaint);

    _drawDash(canvas: canvas, radius: radius * 0.9);
  }

  void _drawDash({required Canvas canvas, required double radius}) {
    const angle = 2 * math.pi / 60;

    final bush = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();

    // drawing
    // canvas.translate(radius, radius);
    for (int i = 0; i < 60; i++) {
      //make the length and stroke of the tick marker longer and thicker depending
      final drawHourHand = i % 5 == 0;
      final tickMarkLength = drawHourHand ? 15 : 10;
      bush.strokeWidth = drawHourHand ? 2 : 1;
      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius + tickMarkLength), bush);

      if (drawHourHand) {
        canvas.save();
        canvas.translate(0.0, radius * -0.8);

        final textPainter = TextPainter()
          ..text = TextSpan(
            text: '${i == 0 ? 12 : (i ~/ 5)}',
            style: TextStyle(
              color: hourColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
          ..textDirection = TextDirection.ltr
          ..textAlign = TextAlign.center
          ..layout();

        /// helps make the text painted vertically
        canvas.rotate(-angle * i);

        textPainter.layout();

        textPainter.paint(canvas,
            Offset(-(textPainter.width / 2), -(textPainter.height / 2)));

        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MainPainter extends CustomPainter {
  final Color backgroundColor;

  final Dash hourDash;
  final Dash minuteDash;
  final Dash secondDash;

  final DateTime time;

  _MainPainter({
    required this.time,
    required this.backgroundColor,
    this.hourDash = const Dash(
      width: 7,
      length: 0.4,
      color: Colors.black,
    ),
    this.minuteDash = const Dash(
      width: 4,
      length: 0.75,
      color: Colors.grey,
    ),
    this.secondDash = const Dash(
      width: 3,
      length: 0.75,
      color: Colors.red,
    ),
  });

  @override
  void paint(Canvas canvas, Size size) {
    var secHandBrush = secondDash.paint;
    var minHandBrush = minuteDash.paint;
    var hourHandBrush = hourDash.paint;
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(radius, radius);

    canvas.drawLine(
        Offset.zero,
        _offset(
          radius: radius,
          length: hourDash.length,
          degree: _hourDegree,
        ),
        hourHandBrush);
    canvas.drawLine(
        Offset.zero,
        _offset(
          radius: radius,
          length: minuteDash.length,
          degree: _minuteDegree,
        ),
        minHandBrush);
    canvas.drawLine(
        Offset.zero,
        _offset(
          radius: radius,
          length: secondDash.length,
          degree: _secondDegree,
        ),
        secHandBrush);

    canvas.drawCircle(Offset.zero, radius * 0.05, centerDotBrush);

    canvas.restore();
  }

  Offset _offset(
      {required double radius,
      required double degree,
      required double length}) {
    var x = radius * length * math.cos(degree);
    var y = radius * length * math.sin(degree);
    return Offset(x, y);
  }

  double get _hourDegree {
    const offside = 3;
    const degreePerHour = 360 / 12;
    final totalHour = time.hour + time.minuteToHour + time.secondToHour;
    return ((totalHour - offside) * degreePerHour) * math.pi / 180;
  }

  double get _minuteDegree {
    const offside = 15;
    const degreePerMinute = 360 / 60;
    final total = time.minute + time.secondToMinute;
    return ((total - offside) * degreePerMinute) * math.pi / 180;
  }

  double get _secondDegree {
    const offside = 15;
    const degreePerSecond = 360 / 60;
    final total = time.second + time.millisecondToSecond;
    return ((total - offside) * degreePerSecond) * math.pi / 180;
  }

  Paint get centerDotBrush => Paint()..color = backgroundColor;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Dash {
  final double length;
  final double width;
  final Color color;

  const Dash({
    required this.length,
    required this.width,
    required this.color,
  });

  Paint get paint => Paint()
    ..color = color
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeWidth = width;
}
