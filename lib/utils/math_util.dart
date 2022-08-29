import 'dart:math' as math;
import 'package:flutter/widgets.dart';

class MathUtil {
  double offsetToClockDegree(Offset offset) {
    final rad = offset.direction;

    late double degree;
    if (rad < 0) {
      degree = 180 / math.pi * (2 * math.pi + rad);
    } else {
      degree = 180 / math.pi * rad;
    }

    if (degree < 270) {
      degree += 90;
    } else {
      degree = degree - 270;
    }

    return degree;
  }

  int degreeToClockHour(double degree) {
    const clockHourPerDegree = 360 / 12;
    return (degree + clockHourPerDegree / 2) ~/ clockHourPerDegree;
  }

  int degreeToClockMinute(double degree) {
    const clockMinutePerDegree = 360 / 60;
    return (degree + clockMinutePerDegree / 2) ~/ clockMinutePerDegree;
  }

  int degreeToClockSecond(double degree) {
    const clockSecondPerDegree = 360 / 60;
    return (degree + clockSecondPerDegree / 2) ~/ clockSecondPerDegree;
  }

  int clockHourToDegree(int hour) {
    if (hour >= 12) {
      hour -= 12;
    }
    return hour * 30;
  }

  int clockMinuteToDegree(int minute) {
    return minute * 6;
  }

  int clockSecondToDegree(int second) {
    return second * 6;
  }

  double clockDistance(int clockInitial, double currentDegree) {
    final zeroPosition = clockInitial < currentDegree ? clockInitial : currentDegree;
    final outerPosition = clockInitial > currentDegree ? clockInitial : currentDegree;
    return (outerPosition - zeroPosition) as double;
  }
}
