import 'package:flutter/material.dart';
import 'dart:math' as math;

class ClockPainter extends CustomPainter {
  final DateTime time;
  final List<String> earthlyBranches = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ];

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    int hour = time.hour;

    // Correct calculation for Chinese hour (shichen) index
    final currentBranchIndex =
        ((hour + 1) % 24) ~/ 2; // Adjust for Zi hour starting at 23:00
    final adjustedBranchIndex = currentBranchIndex % 12;

    // Draw clock hands
    // 绘制指针, 调整长度和样式
    final secondRadiusFactor = 0.85;
    final minuteRadiusFactor = 0.7;
    final hourRadiusFactor = 0.5;

    // 定义画笔
    final secondHandPaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round;

    // Second hand
    final secondAngle = (math.pi / 30 * time.second) - math.pi / 2;
    final secondEnd = Offset(
      center.dx + radius * secondRadiusFactor * math.cos(secondAngle),
      center.dy + radius * secondRadiusFactor * math.sin(secondAngle),
    );
    canvas.drawLine(center, secondEnd, secondHandPaint);

    // Minute hand
    final minuteAngle =
        (math.pi / 30 * time.minute + math.pi / 1800 * time.second) -
        math.pi / 2;
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * math.cos(minuteAngle),
      center.dy + radius * minuteRadiusFactor * math.sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // Hour hand (24-hour format)
    // 修改此处，保证时针在23点时指向“子”
    final hourAngle = (math.pi / 12 * ((hour + 11) % 24)) - math.pi / 2;
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * math.cos(hourAngle),
      center.dy + radius * hourRadiusFactor * math.sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.time != time;
}
