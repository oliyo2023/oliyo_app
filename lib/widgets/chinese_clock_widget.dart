import 'dart:math';
import 'package:flutter/material.dart';

// The new StatelessWidget for the clock
class ChineseClockWidget extends StatelessWidget {
  final DateTime time;
  final double width;
  final double height;

  const ChineseClockWidget({
    super.key,
    required this.time,
    this.width = 320, // Default size, can be overridden
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: ClockPainter(time)),
    );
  }
}

// Copied ClockPainter class from home_page.dart
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
    final radius = min(size.width, size.height) / 2;
    int hour = time.hour;
    // Correct calculation for Chinese hour (shichen) index
    final currentBranchIndex =
        ((hour + 1) % 24) ~/ 2; // Adjust for Zi hour starting at 23:00
    final adjustedBranchIndex = currentBranchIndex % 12;
    final innerRadiusFactor = 0.7;
    final innerRadius = radius * innerRadiusFactor;

    // Draw blue gradient background
    final gradient = RadialGradient(
      colors: [Colors.blue.shade200, Colors.blue.shade800],
    );
    final backgroundPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          );
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw clock face border
    final borderPaint =
        Paint()
          ..color = Colors.grey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw inner circle border
    canvas.drawCircle(center, innerRadius, borderPaint);

    // Draw 24-hour marks and numbers
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i - pi / 2;
      final isMain = i % 2 == 0;
      final length = isMain ? 8 : 4;
      final strokeWidth = isMain ? 1.5 : 1.0;

      final tickPaint =
          Paint()
            ..color = Colors.grey.shade300
            ..strokeWidth = strokeWidth;

      final startPoint = Offset(
        center.dx + (radius - 5) * cos(angle),
        center.dy + (radius - 5) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius - 5 - length) * cos(angle),
        center.dy + (radius - 5 - length) * sin(angle),
      );
      if (!isMain) {
        canvas.drawLine(startPoint, endPoint, tickPaint);
      }

      // Draw 24-hour numbers
      final hourNumber = (i == 0 ? 24 : i);
      final textAngle = angle;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hourNumber.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        center.dx + (radius - 23) * cos(textAngle) - textPainter.width / 2,
        center.dy + (radius - 23) * sin(textAngle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Draw Earthly Branch segments and text
    for (var i = 0; i < 12; i++) {
      final startAngle = -pi / 2 + pi / 6 * i;
      final sweepAngle = pi / 6;
      final isCurrent = i == adjustedBranchIndex;

      final segmentPaint =
          Paint()
            ..shader = SweepGradient(
              center: Alignment.center,
              colors: [
                isCurrent ? Colors.cyan.shade300 : Colors.blue.shade700,
                isCurrent ? Colors.cyan.shade500 : Colors.blue.shade900,
              ],
              startAngle: startAngle,
              endAngle: startAngle + sweepAngle,
            ).createShader(
              Rect.fromCircle(center: center, radius: innerRadius),
            );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sweepAngle,
        true,
        segmentPaint,
      );

      // Draw Earthly Branch text
      final branchTextPainter = TextPainter(
        text: TextSpan(
          text: earthlyBranches[i],
          style: TextStyle(
            color: isCurrent ? Colors.black : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      branchTextPainter.layout();
      final segmentCenterAngle = startAngle + pi / 12;
      final textOffset = Offset(
        center.dx +
            (innerRadius * 0.7) * cos(segmentCenterAngle) -
            branchTextPainter.width / 2,
        center.dy +
            (innerRadius * 0.7) * sin(segmentCenterAngle) -
            branchTextPainter.height / 2,
      );
      branchTextPainter.paint(canvas, textOffset);

      // Draw dividing lines between segments on the inner circle
      final dividerStart = Offset(
        center.dx + innerRadius * cos(startAngle + sweepAngle),
        center.dy + innerRadius * sin(startAngle + sweepAngle),
      );
      final dividerEnd = Offset(
        center.dx + radius * cos(startAngle + sweepAngle),
        center.dy + radius * sin(startAngle + sweepAngle),
      );
      canvas.drawLine(dividerStart, dividerEnd, borderPaint..strokeWidth = 1);
    }

    // Draw clock hands
    final secondRadiusFactor = 0.85;
    final minuteRadiusFactor = 0.7;
    final hourRadiusFactor = 0.5;

    final secondHandPaint =
        Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade300 // Use one color definition
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color =
              Colors
                  .white // Use one color definition
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    // Second hand
    final secondAngle = (pi / 30 * time.second) - pi / 2;
    final secondEnd = Offset(
      center.dx + radius * secondRadiusFactor * cos(secondAngle),
      center.dy + radius * secondRadiusFactor * sin(secondAngle),
    );
    canvas.drawLine(center, secondEnd, secondHandPaint);

    // Minute hand
    final minuteAngle =
        (pi / 30 * time.minute + pi / 1800 * time.second) - pi / 2;
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * cos(minuteAngle),
      center.dy + radius * minuteRadiusFactor * sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // Hour hand (24-hour format)
    final hourAngle =
        (pi / 12 * (time.hour % 24) + pi / 720 * time.minute) - pi / 2;
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle),
      center.dy + radius * hourRadiusFactor * sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // Draw center dot
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.time != time;
}
