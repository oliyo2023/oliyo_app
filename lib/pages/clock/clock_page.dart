import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/chinese_calendar.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
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
      appBar: AppBar(title: const Text('中国时辰时钟(24小时制)')),
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
    );
  }
}

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
    final currentBranchIndex = (hour % 24) ~/ 2;
    final adjustedBranchIndex = currentBranchIndex % 12;
    final innerRadiusFactor = 0.7;
    final innerRadius = radius * innerRadiusFactor;

    // 绘制紫色渐变背景
    final gradient = RadialGradient(
      colors: [Colors.purple[300]!, Colors.purple[800]!],
    );
    final backgroundPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          );
    canvas.drawCircle(center, radius, backgroundPaint);

    // 绘制表盘边框
    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);

    // 绘制内圆
    canvas.drawCircle(center, innerRadius, borderPaint);

    // 绘制24小时刻度
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i;
      final isMain = i % 2 == 0;
      final length = isMain ? 1 : 0.5;
      final strokeWidth = isMain ? 0.8 : 0.5;
      final tickPaint =
          Paint()
            ..color = Colors.black
            ..strokeWidth = strokeWidth;

      if (isMain) {
        continue; // Skip drawing tick marks where numbers are drawn
      }

      final start = Offset(
        center.dx + (radius - 20) * cos(angle - pi / 2),
        center.dy + (radius - 20) * sin(angle - pi / 2),
      );
      final end = Offset(
        center.dx + (radius - 20 - length - 8) * cos(angle - pi / 2),
        center.dy + (radius - 20 - length - 8) * sin(angle - pi / 2),
      );

      canvas.drawLine(start, end, tickPaint);

      // 绘制1-24数字 - 使用明亮颜色，更大字体

      // if (!isMain) { // Only draw numbers for main hours - removed condition to draw numbers for all hours

      final hour = i == 0 ? 24 : i;
      final textAngle = angle - pi / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hour.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontSize: 18,
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
      // }
    }

    // 绘制地支扇形区域和文字
    for (var i = 0; i < 12; i++) {
      final startAngle = -pi / 2 + pi / 6 * i;
      final endAngle = -pi / 2 + pi / 6 * (i + 1);
      final isCurrent = i == adjustedBranchIndex;

      // 绘制扇形背景 - 渐变色,  Current segment to lighter Grey, use Colors.grey, use lightBlueGrey - CORRECTED COLOR HERE to lightGrey - now light grey - now light grey again - now light green accent - now light cyan accent - now light grey - now light orange - now lime - now grey - now orange accent - final orange - final lighter orange - final lighter orange/yellow - final light grey - final light green - final light blue grey - final light orange red - final orange red - final remove red
      final segmentPaint =
          Paint()
            ..shader = SweepGradient(
              center: Alignment.center,
              colors: [
                isCurrent
                    ? Colors.orangeAccent.shade100
                    : Colors
                        .purple
                        .shade400, // lightOrangeAccent for current segment - CORRECTED COLOR HERE to lightGrey - now light grey - now light grey again - now light green accent - now light cyan accent - now light grey - now light orange - now light orange accent - final orange - final lighter orange - final lighter orange/yellow - final light grey - final light green - final light blue grey - final light orange red - final orange red - final remove red
                isCurrent
                    ? Colors.orangeAccent.shade200
                    : Colors
                        .purple
                        .shade900, // Darker lightOrangeAccent -  CORRECTED COLOR HERE to lightGrey - now light grey - now light grey again - now light green accent - now light cyan accent - now light grey - now light orange - now light orange accent - final orange - final lighter orange - final lighter orange/yellow - final light grey - final light green - final light blue grey - final light orange red - final orange red - final remove red
              ],
              startAngle: startAngle,
              endAngle: endAngle,
            ).createShader(
              Rect.fromCircle(center: center, radius: innerRadius),
            );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        pi / 6,
        true,
        segmentPaint,
      );

      // 绘制地支文字 - 更大字体，内圆中心
      final textPainter = TextPainter(
        text: TextSpan(
          text: earthlyBranches[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final segmentCenterAngle = startAngle + pi / 12;
      final textOffset = Offset(
        center.dx +
            (innerRadius * 0.7) * cos(segmentCenterAngle) -
            textPainter.width / 2,
        center.dy +
            (innerRadius * 0.7) * sin(segmentCenterAngle) -
            textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);

      // 绘制分割刻度 - 内圆和外圆之间 - shorten length even more
      final tickMarkStart = Offset(
        center.dx + innerRadius * cos(endAngle),
        center.dy + innerRadius * sin(endAngle),
      );
      final tickMarkEnd = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );
      canvas.drawLine(tickMarkStart, tickMarkEnd, borderPaint);
    }

    // 绘制指针, 极短指针长度, 颜色区分更明显
    final secondRadiusFactor = 0.5;
    final minuteRadiusFactor = 0.4;
    final hourRadiusFactor = 0.25;

    final secondHandPaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color = Colors.grey[500]!
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

    // 秒针
    final secondAngle = pi / 30 * time.second;
    final secondEnd = Offset(
      center.dx + radius * secondRadiusFactor * cos(secondAngle - pi / 2),
      center.dy + radius * secondRadiusFactor * sin(secondAngle - pi / 2),
    );
    canvas.drawLine(center, secondEnd, secondHandPaint);

    // 分针
    final minuteAngle = pi / 30 * time.minute;
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * cos(minuteAngle - pi / 2),
      center.dy + radius * minuteRadiusFactor * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // 时针
    final hourAngle =
        pi / 12 * (time.hour % 24) +
        pi / 720 * time.minute; // Adjusted hour angle calculation
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle - pi / 2),
      center.dy + radius * hourRadiusFactor * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
