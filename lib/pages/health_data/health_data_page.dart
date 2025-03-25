import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthDataPage extends StatelessWidget {
  const HealthDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康数据'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 健康状态卡片
              _buildHealthStatusCard(),
              const SizedBox(height: 24),

              // 健康恢复时间线
              const Text(
                '健康恢复时间线',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildHealthTimeline(),

              const SizedBox(height: 24),

              // 健康建议
              const Text(
                '健康建议',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildHealthTips(),
            ],
          ),
        ),
      ),
    );
  }

  // 健康状态卡片
  Widget _buildHealthStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '您的健康状态',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthIndicator('心率', '72', '次/分', Colors.red),
                _buildHealthIndicator('血压', '120/80', 'mmHg', Colors.blue),
                _buildHealthIndicator('肺活量', '85', '%', Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            const Text(
              '您的健康状况正在稳步恢复中，继续保持！',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 健康指标项
  Widget _buildHealthIndicator(
    String title,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(unit, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ],
    );
  }

  // 健康恢复时间线
  Widget _buildHealthTimeline() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimelineItem('20分钟', '血压和脉搏恢复正常', true),
            _buildTimelineItem('12小时', '血液中的一氧化碳水平恢复正常', true),
            _buildTimelineItem('2天', '嗅觉和味觉开始增强', true),
            _buildTimelineItem('2-3周', '肺功能开始改善，运动能力增强', false),
            _buildTimelineItem('1-9个月', '咳嗽和呼吸短促减少', false),
            _buildTimelineItem('1年', '冠心病风险降低一半', false, isLast: true),
          ],
        ),
      ),
    );
  }

  // 时间线项目
  Widget _buildTimelineItem(
    String time,
    String description,
    bool completed, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? const Color(0xFF4CAF50) : Colors.grey,
              ),
              child:
                  completed
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: completed ? const Color(0xFF4CAF50) : Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: completed ? const Color(0xFF4CAF50) : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: completed ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  // 健康建议
  Widget _buildHealthTips() {
    return Column(
      children: [
        _buildTipCard(
          '增加体育活动',
          '每天进行30分钟的中等强度运动，如快走、游泳或骑自行车，有助于改善肺功能和心血管健康。',
          Icons.directions_run,
        ),
        const SizedBox(height: 12),
        _buildTipCard(
          '健康饮食',
          '增加水果、蔬菜和全谷物的摄入，减少加工食品和高糖食物，有助于身体恢复和维持健康体重。',
          Icons.restaurant,
        ),
        const SizedBox(height: 12),
        _buildTipCard('充足睡眠', '保持每晚7-8小时的优质睡眠，有助于身体恢复和减轻戒烟期间的压力。', Icons.hotel),
      ],
    );
  }

  // 建议卡片
  Widget _buildTipCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE1BEE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF9C27B0)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(content, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
