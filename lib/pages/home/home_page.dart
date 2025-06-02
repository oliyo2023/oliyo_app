import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/chinese_calendar.dart'; // Corrected import path
import 'package:lunar/lunar.dart';
import '../../widgets/jumping_text.dart'; // 导入 JumpingText Widget

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
      backgroundColor: Colors.white, // 更新背景色为白色
      // Removed AppBar to make it cleaner for the home page, can be added back if needed
      body: Stack(
        // 使用 Stack 进行叠加
        children: [
          // 主要内容区域
          Center(
            child: SingleChildScrollView(
              // Add SingleChildScrollView to prevent overflow if content is too long
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .center, // Ensure children are centered horizontally
                children: [
                  const SizedBox(height: 60), // 调整顶部间距以匹配紫色区域高度
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: CustomPaint(painter: ClockPainter(_currentTime)),
                  ),
                  const SizedBox(height: 20), // 在时钟和跳动文字之间添加一些间距
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: JumpingText(
                        text: 'OLIYO',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        jumpHeight: 16.0,
                        duration: Duration(milliseconds: 1000),
                        staggerDelay: Duration(milliseconds: 150),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // 增加时钟和下方信息的间距
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ), // 给文本区域添加水平内边距
                    child: Column(
                      children: [
                        Text(
                          '${_currentTime.year}年${_currentTime.month}月${_currentTime.day}日 ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
                          style:
                              Theme.of(context).textTheme.titleLarge, // 使用主题样式
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8), // 调整间距
                        Text(
                          ChineseCalendar.getFullGanzhiDate(_currentTime),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // 使用主题的主色调
                          ), // 使用主题样式并应用主色调
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8), // 调整间距
                        Text(
                          '农历：${_currentLunar.toString()}',
                          style:
                              Theme.of(context).textTheme.titleMedium, // 使用主题样式
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16), // 增加宜忌前的间距
                        Row(
                          // 使用 Row 格式化“宜”
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '宜：',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 让内容自动换行
                              child: Text(
                                _currentLunar.getDayYi().join(' '), // 用空格连接列表项
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // 宜忌之间的间距
                        Row(
                          // 使用 Row 格式化“忌”
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '忌：',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              // 让内容自动换行
                              child: Text(
                                _currentLunar.getDayJi().join(' '), // 用空格连接列表项
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 顶部的渐变遮罩区域
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.95),
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
        ],
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
    // 绘制红色/金色渐变背景
    final gradient = RadialGradient(
      colors: [Colors.red.shade300, Colors.red.shade900], // 使用红色渐变
      // 可以考虑加入金色元素，例如：
      // colors: [Colors.yellow.shade600, Colors.red.shade900],
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
          ..color =
              Colors
                  .amber
                  .shade600 // 边框颜色改为金色
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw inner circle border
    canvas.drawCircle(center, innerRadius, borderPaint);

    // Draw 24-hour marks and numbers
    for (var i = 0; i < 24; i++) {
      final angle = pi / 12 * i - pi / 2; // Adjust angle to start from top
      final isMain = i % 2 == 0; // 主刻度 (地支对应位置)
      final length = isMain ? 8 : 4; // 调整刻度长度
      final strokeWidth = isMain ? 1.5 : 1.0; // 调整刻度粗细

      final tickPaint =
          Paint()
            ..color =
                Colors
                    .amber
                    .shade200 // 刻度颜色改浅金色
            ..strokeWidth = strokeWidth;

      final startPoint = Offset(
        center.dx + (radius - 5) * cos(angle), // Start from outer edge
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
      final hourNumber = (i == 0 ? 24 : i); // Display 24 instead of 0
      final textAngle = angle;
      final textPainter = TextPainter(
        text: TextSpan(
          text: hourNumber.toString(),
          style: const TextStyle(
            color: Colors.yellowAccent, // 数字颜色保持亮黄色，或改为白色/金色
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
      // Calculate angles for each 2-hour segment
      final startAngle = -pi / 2 + pi / 6 * i;
      final sweepAngle = pi / 6;
      final isCurrent = i == adjustedBranchIndex;

      // 绘制扇形背景 - 使用红色系，当前时辰用亮黄色高亮
      final segmentPaint =
          Paint()
            ..shader = SweepGradient(
              center: Alignment.center,
              colors: [
                isCurrent
                    ? Colors
                        .yellow
                        .shade400 // 当前时辰亮黄色
                    : Colors.red.shade700, // 非当前时辰深红色
                isCurrent
                    ? Colors
                        .yellow
                        .shade600 // 当前时辰深黄色
                    : Colors.red.shade900, // 非当前时辰更深的红色
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
            color: isCurrent ? Colors.black : Colors.white, // 高亮时黑色，否则白色
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
      canvas.drawLine(
        dividerStart,
        dividerEnd,
        borderPaint
          ..strokeWidth = 1
          ..color = Colors.amber.shade400, // 分割线用浅金色
      );
    }

    // Draw clock hands
    // 绘制指针, 调整长度和样式
    final secondRadiusFactor = 0.85;
    final minuteRadiusFactor = 0.7;
    final hourRadiusFactor = 0.5;

    final secondHandPaint =
        Paint()
          ..color =
              Colors
                  .white // 秒针改为白色，更醒目
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round;

    final minuteHandPaint =
        Paint()
          ..color =
              Colors
                  .amber
                  .shade300 // 分针改为浅金色
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round;

    final hourHandPaint =
        Paint()
          ..color =
              Colors
                  .amber
                  .shade600 // 时针改为深金色
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
    final hourAngle = (pi / 12 * (time.hour % 24) + pi / 720 * time.minute) - pi / 2;
    final hourEnd = Offset(
      center.dx + radius * hourRadiusFactor * cos(hourAngle),
      center.dy + radius * hourRadiusFactor * sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // Draw center dot
    final centerDotPaint = Paint()..color = Colors.amber.shade600; // 中心点改为金色
    canvas.drawCircle(center, 4, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) => oldDelegate.time != time;
}
