import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/chinese_calendar.dart'; // Corrected import path
import 'package:lunar/lunar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  Lunar _currentLunar = Lunar.fromDate(DateTime.now()); // 添加农历日期

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _currentTime = DateTime.now();
          _currentLunar = Lunar.fromDate(_currentTime); // 更新农历日期
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
              '${_currentTime.year}年${_currentTime.month}月${_currentTime.day}日 ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              ChineseCalendar.getFullGanzhiDate(_currentTime),
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            Text(
              // 添加农历信息
              '农历：${_currentLunar.toString()}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              '宜：${_currentLunar.getDayYi()}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              '忌：${_currentLunar.getDayJi()}',
              style: const TextStyle(fontSize: 20),
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
    // 绘制蓝色渐变背景
    final gradient = RadialGradient(
      colors: [Colors.blue.shade200, Colors.blue.shade800],
    ); // 使用蓝色渐变
    final backgroundPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          );
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw clock face border
    final borderPaint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade400 // 边框颜色改浅
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2; // 边框稍微变细
    canvas.drawCircle(center, radius, borderPaint);

    // Draw inner circle border
    canvas.drawCircle(center, innerRadius, borderPaint);

    // Draw 24-hour marks and numbers
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i - pi / 2; // Adjust angle to start from top
      final isMain = i % 2 == 0; // 主刻度 (地支对应位置) - Renamed for consistency
      final length = isMain ? 8 : 4; // 调整刻度长度 - Renamed for consistency
      final strokeWidth =
          isMain ? 1.5 : 1.0; // 调整刻度粗细 - Renamed for consistency

      final tickPaint =
          Paint()
            ..color =
                Colors
                    .grey
                    .shade300 // 刻度颜色改浅
            ..strokeWidth = strokeWidth; // Use consistent variable name

      final startPoint = Offset(
        center.dx + (radius - 5) * cos(angle), // Start from outer edge
        center.dy + (radius - 5) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius - 5 - length) * cos(angle),
        center.dy +
            (radius - 5 - length) * sin(angle), // Corrected: Use 'length'
      );
      if (!isMain) {
        canvas.drawLine(startPoint, endPoint, tickPaint);
      }

      // Draw 24-hour numbers
      // Removed the black line drawing above odd numbers

      final hourNumber = (i == 0 ? 24 : i); // Display 24 instead of 0
      final textAngle = angle;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hourNumber.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontSize: 16, // 保持字体大小
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        center.dx +
            (radius - 23) * // Use consistent positioning logic
                cos(textAngle) - // Adjust position
            textPainter.width / 2, // Adjust position outward
        center.dy +
            (radius - 23) * // Use consistent positioning logic
                sin(textAngle) - // Adjust position
            textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Draw Earthly Branch segments and text
    for (var i = 0; i < 12; i++) {
      // Calculate angles for each 2-hour segment
      final startAngle = -pi / 2 + pi / 6 * i; // Use original angle calculation
      final sweepAngle = pi / 6;
      final isCurrent = i == adjustedBranchIndex;

      // 绘制扇形背景 - 使用蓝色系，当前时辰用青色高亮
      final segmentPaint =
          Paint()
            ..shader = SweepGradient(
              center: Alignment.center,
              colors: [
                isCurrent
                    ? Colors
                        .cyan
                        .shade300 // 当前时辰亮青色
                    : Colors.blue.shade700, // 非当前时辰深蓝色
                isCurrent
                    ? Colors
                        .cyan
                        .shade500 // 当前时辰深青色
                    : Colors.blue.shade900, // 非当前时辰更深的蓝色
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
        // Rename to avoid conflict
        text: TextSpan(
          text: earthlyBranches[i],
          style: TextStyle(
            color:
                isCurrent ? Colors.black : Colors.white, // Keep highlight logic
            fontSize: 22, // Use consistent font size
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      branchTextPainter.layout();
      // branchTextPainter.layout(); // Corrected: Use branchTextPainter - This line was duplicated, removing the incorrect one
      final segmentCenterAngle =
          startAngle + pi / 12; // Use consistent angle calculation
      final textOffset = Offset(
        center.dx +
            (innerRadius * 0.7) *
                cos(segmentCenterAngle) - // Use consistent positioning
            branchTextPainter.width / 2, // Corrected: Use branchTextPainter
        center.dy +
            (innerRadius * 0.7) *
                sin(segmentCenterAngle) - // Use consistent positioning
            branchTextPainter.height / 2, // Corrected: Use branchTextPainter
      );
      branchTextPainter.paint(
        canvas,
        textOffset,
      ); // Corrected: Use branchTextPainter

      // Draw dividing lines between segments on the inner circle
      final dividerStart = Offset(
        center.dx + innerRadius * cos(startAngle + sweepAngle),
        center.dy +
            innerRadius *
                sin(startAngle + sweepAngle), // Use endAngle for consistency
      );
      final dividerEnd = Offset(
        center.dx +
            radius *
                cos(startAngle + sweepAngle), // Use endAngle for consistency
        center.dy +
            radius *
                sin(startAngle + sweepAngle), // Use endAngle for consistency
      );
      canvas.drawLine(
        dividerStart,
        dividerEnd,
        borderPaint..strokeWidth = 1,
      ); // Thinner divider lines
    }

    // Draw clock hands
    // 绘制指针, 调整长度和样式
    final secondRadiusFactor = 0.85; // 秒针长一些
    final minuteRadiusFactor = 0.7; // 分针次之
    final hourRadiusFactor = 0.5; // 时针最短

    final secondHandPaint =
        Paint()
          ..color =
              Colors
                  .redAccent // Brighter red
          ..strokeWidth =
              1.0 // Thinner second hand
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color =
              Colors
                  .white // White for better contrast
          ..color =
              Colors
                  .grey
                  .shade300 // 分针颜色改浅灰
          ..strokeWidth =
              3.0 // Keep thickness
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color =
              Colors
                  .amber // Amber for hour hand
          ..color =
              Colors
                  .white // 时针改白色
          ..strokeWidth =
              4.0 // Keep thickness
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
        pi / 2; // Keep smooth movement
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * cos(minuteAngle),
      center.dy + radius * minuteRadiusFactor * sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // Hour hand (24-hour format)
    final hourAngle =
        (pi / 12 * (time.hour % 24) + pi / 720 * time.minute) -
        pi / 2; // Keep 24h adjustment
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle),
      center.dy + radius * hourRadiusFactor * sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // Draw center dot
    // 绘制中心圆点
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerDotPaint); // Single white dot
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.time != time; // Only repaint if time changes
}
