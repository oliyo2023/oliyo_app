import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/chinese_calendar.dart'; // Corrected import path

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _currentTime = DateTime.now();
        });
      } else {
        timer.cancel(); // Cancel timer if widget is disposed
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar to make it cleaner for the home page, can be added back if needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 320,
              child: CustomPaint(painter: ClockPainter(_currentTime)),
            ),
            const SizedBox(height: 20),
            Text(
              '${_currentTime.year}年${_currentTime.month}月${_currentTime.day}日',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              ChineseCalendar.getFullGanzhiDate(_currentTime),
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
      ),
      // Removed BottomNavigationBar
    );
  }
}

// Copied ClockPainter class from clock_page.dart
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

    // Draw purple gradient background
    final gradient = RadialGradient(
      colors: [Colors.purple[300]!, Colors.purple[800]!],
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
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw inner circle border
    canvas.drawCircle(center, innerRadius, borderPaint);

    // Draw 24-hour marks and numbers
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i - pi / 2; // Adjust angle to start from top
      final isMainHour = i % 2 == 0; // Main hours for Earthly Branches
      final tickLength = isMainHour ? 10 : 5; // Longer ticks for main hours
      final tickWidth = isMainHour ? 2.0 : 1.0;

      final tickPaint =
          Paint()
            ..color =
                Colors
                    .white // White ticks for better visibility
            ..strokeWidth = tickWidth;

      final startPoint = Offset(
        center.dx + (radius - 5) * cos(angle), // Start from outer edge
        center.dy + (radius - 5) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius - 5 - tickLength) * cos(angle),
        center.dy + (radius - 5 - tickLength) * sin(angle),
      );
      canvas.drawLine(startPoint, endPoint, tickPaint);

      // Draw 24-hour numbers
      if (i % 2 != 0) {
        // Draw black line above odd numbers
        final lineStart = Offset(
          center.dx + (radius - 20) * cos(angle),
          center.dy + (radius - 20) * sin(angle) - 8, // Adjust position
        );
        final lineEnd = Offset(
          center.dx + (radius - 10) * cos(angle),
          center.dy + (radius - 10) * sin(angle) - 8, // Adjust position
        );
        canvas.drawLine(lineStart, lineEnd, borderPaint..strokeWidth = 2);
      }
      final hourNumber = (i == 0 ? 24 : i); // Display 24 instead of 0
      final textAngle = angle;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hourNumber.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontSize: 16, // Slightly smaller font size
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        center.dx +
            (radius - 30 - (isMainHour ? 5 : 0)) *
                cos(textAngle) - // Adjust position
            textPainter.width / 2, // Adjust position outward
        center.dy +
            (radius - 30 - (isMainHour ? 5 : 0)) *
                sin(textAngle) - // Adjust position
            textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Draw Earthly Branch segments and text
    for (var i = 0; i < 12; i++) {
      // Calculate angles for each 2-hour segment
      final startAngle = -pi / 2 + pi / 6 * i - pi / 12; // Center branch text
      final sweepAngle = pi / 6;
      final isCurrent = i == adjustedBranchIndex;

      // Draw segment background gradient
      final segmentPaint =
          Paint()
            ..shader = SweepGradient(
              center: Alignment.center,
              colors: [
                isCurrent
                    ? Colors.orangeAccent.shade100
                    : Colors.purple.shade400.withAlpha(
                      // Removed unnecessary !
                      204,
                    ), // Replaced withOpacity with withAlpha
                isCurrent
                    ? Colors.orangeAccent.shade200
                    : Colors.purple.shade900.withAlpha(
                      // Removed unnecessary !
                      204,
                    ), // Replaced withOpacity with withAlpha
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
      final textPainter = TextPainter(
        text: TextSpan(
          text: earthlyBranches[i],
          style: TextStyle(
            color:
                isCurrent
                    ? Colors.black
                    : Colors.white, // Highlight current branch text
            fontSize: 20, // Larger font size for branches
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final segmentCenterAngle = startAngle + sweepAngle / 2;
      final textOffset = Offset(
        center.dx +
            (innerRadius * 0.65) * cos(segmentCenterAngle) -
            textPainter.width / 2, // Position text within segment
        center.dy +
            (innerRadius * 0.65) * sin(segmentCenterAngle) -
            textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);

      // Draw dividing lines between segments on the inner circle
      final dividerStart = Offset(
        center.dx + innerRadius * cos(startAngle + sweepAngle),
        center.dy + innerRadius * sin(startAngle + sweepAngle),
      );
      final dividerEnd = Offset(
        center.dx +
            radius * cos(startAngle + sweepAngle), // Extend to outer radius
        center.dy + radius * sin(startAngle + sweepAngle),
      );
      canvas.drawLine(
        dividerStart,
        dividerEnd,
        borderPaint..strokeWidth = 1,
      ); // Thinner divider lines
    }

    // Draw clock hands
    final secondRadiusFactor = 0.6; // Adjusted lengths
    final minuteRadiusFactor = 0.5;
    final hourRadiusFactor = 0.35;

    final secondHandPaint =
        Paint()
          ..color =
              Colors
                  .redAccent // Brighter red
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color =
              Colors
                  .white // White for better contrast
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color =
              Colors
                  .amber // Amber for hour hand
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
        (pi / 30 * time.minute + pi / 1800 * time.second) -
        pi / 2; // Include seconds for smooth movement
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * cos(minuteAngle),
      center.dy + radius * minuteRadiusFactor * sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // Hour hand (24-hour format)
    final hourAngle =
        (pi / 12 * (time.hour % 24) + pi / 720 * time.minute) -
        pi / 2; // Adjusted for 24h and minutes
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle),
      center.dy + radius * hourRadiusFactor * sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // Draw center dot
    final centerDotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 5, centerDotPaint);
    final centerDotHighlightPaint = Paint()..color = Colors.grey[300]!;
    canvas.drawCircle(center, 3, centerDotHighlightPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.time != time; // Only repaint if time changes
}
