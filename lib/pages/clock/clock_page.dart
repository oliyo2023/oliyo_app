import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/chinese_calendar.dart';
import 'package:get/get.dart'; // 导入 Get
import '../../services/time_service.dart'; // 导入 TimeService

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer _timer;
  late DateTime _currentTime; // 改为 late，在 initState 中初始化
  final TimeService timeService = Get.find<TimeService>(); // 获取 TimeService 实例

  @override
  void initState() {
    super.initState();
    _currentTime = timeService.getCorrectedTime(); // 在 initState 开始时获取初始时间
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = timeService.getCorrectedTime(); // 使用校准后的时间
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
            const SizedBox(height: 5), // Add some space
            Text(
              '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ), // Style for the time
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

    // 绘制表盘边框
    final borderPaint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade400 // 边框颜色改浅
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2; // 边框稍微变细
    canvas.drawCircle(center, radius, borderPaint);

    // 绘制内圆
    canvas.drawCircle(center, innerRadius, borderPaint);

    // 绘制24小时刻度
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i;
      final isMain = i % 2 == 0; // 主刻度 (地支对应位置)
      final length = isMain ? 8 : 4; // 调整刻度长度
      final strokeWidth = isMain ? 1.5 : 1.0; // 调整刻度粗细
      final tickPaint =
          Paint()
            ..color =
                Colors
                    .grey
                    .shade300 // 刻度颜色改浅
            ..strokeWidth = strokeWidth;

      if (isMain) {
        continue; // Skip drawing tick marks where numbers are drawn
      }

      final start = Offset(
        center.dx + (radius - 5) * cos(angle - pi / 2), // 调整起始位置靠近边缘
        center.dy + (radius - 5) * sin(angle - pi / 2),
      );
      final end = Offset(
        center.dx + (radius - 5 - length) * cos(angle - pi / 2), // 调整结束位置
        center.dy + (radius - 5 - length) * sin(angle - pi / 2),
      );

      canvas.drawLine(start, end, tickPaint);

      // 绘制1-24数字
      final hour = i == 0 ? 24 : i;
      final textAngle = angle - pi / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hour.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontSize: 16, // 字体稍微调小
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        center.dx + (radius - 23) * cos(textAngle) - textPainter.width / 2,
        center.dy +
            (radius - 23) * sin(textAngle) -
            textPainter.height / 2, // 调整数字位置更靠近边缘
      );
      textPainter.paint(canvas, textOffset);
      // }
    }

    // 绘制地支扇形区域和文字
    for (var i = 0; i < 12; i++) {
      final startAngle = -pi / 2 + pi / 6 * i;
      final endAngle = -pi / 2 + pi / 6 * (i + 1);
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
      final branchTextPainter = TextPainter(
        // 重命名避免冲突
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
    } // 绘制指针, 调整长度和样式
    final secondRadiusFactor = 0.85; // 秒针长一些
    final minuteRadiusFactor = 0.7; // 分针次之
    final hourRadiusFactor = 0.5; // 时针最短

    final secondHandPaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade300 // 分针颜色改浅灰
          ..strokeWidth =
              3.0 // 分针变粗
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth =
              4.0 // 时针加粗
          ..strokeCap = StrokeCap.round;

    // 秒针
    final secondAngle = pi / 30 * time.second;
    final secondEnd = Offset(
      center.dx + radius * secondRadiusFactor * cos(secondAngle - pi / 2),
      center.dy + radius * secondRadiusFactor * sin(secondAngle - pi / 2),
    );
    canvas.drawLine(center, secondEnd, secondHandPaint);

    // 分针
    final minuteAngle =
        pi / 30 * time.minute + pi / 1800 * time.second; // 分针更平滑
    final minuteEnd = Offset(
      center.dx + radius * minuteRadiusFactor * cos(minuteAngle - pi / 2),
      center.dy + radius * minuteRadiusFactor * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, minuteEnd, minuteHandPaint);

    // 时针
    final hourAngle =
        pi / 12 * (time.hour % 24) +
        pi / 720 * time.minute; // Adjusted hour angle calculation
    // pi / (720 * 60) * time.second; // 时针更平滑，可选
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle - pi / 2),
      center.dy + radius * hourRadiusFactor * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // 绘制中心圆点
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerDotPaint);
  } // End of paint method

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
