import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:oliyo_app/pages/home/quit_smoking_home_page.dart';
import 'package:oliyo_app/routes/app_routes.dart';

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
    // final currentBranchIndex =
    //     ((hour + 1) % 24) ~/ 2; // Adjust for Zi hour starting at 23:00
    // final adjustedBranchIndex = currentBranchIndex % 12; // 暂时注释掉未使用的变量

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 每秒更新时间
    Stream.periodic(const Duration(seconds: 1), (i) => DateTime.now()).listen((
      time,
    ) {
      if (mounted) {
        setState(() {
          _currentTime = time;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oliyo App'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 时钟显示区域
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '当前时间',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CustomPaint(painter: ClockPainter(_currentTime)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9C27B0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 快速功能区域
              const Text(
                '快速功能',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQuickActionCard(
                    '戒烟助手',
                    Icons.smoke_free,
                    Colors.green,
                    () => Get.to(() => const QuitSmokingHomePage()),
                  ),
                  _buildQuickActionCard(
                    '时钟',
                    Icons.access_time,
                    Colors.blue,
                    () => Get.toNamed(Routes.clock),
                  ),
                  _buildQuickActionCard(
                    '社区',
                    Icons.people,
                    Colors.orange,
                    () => Get.toNamed(Routes.community),
                  ),
                  _buildQuickActionCard(
                    '消息',
                    Icons.message,
                    Colors.purple,
                    () => Get.toNamed(Routes.message),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
