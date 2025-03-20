import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuitSmokingHomePage extends StatelessWidget {
  const QuitSmokingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI戒烟助手'),
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
              // 用户戒烟状态卡片
              _buildStatusCard(),
              const SizedBox(height: 20),

              // 主要功能区域
              const Text(
                '戒烟工具',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 功能卡片网格
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildFeatureCard(
                    '制定戒烟计划',
                    Icons.calendar_today,
                    Colors.blue,
                    () => Get.toNamed('/smoking_plan'),
                  ),
                  _buildFeatureCard(
                    '资金节约计算',
                    Icons.savings,
                    Colors.green,
                    () => Get.toNamed('/savings_calculator'),
                  ),
                  _buildFeatureCard(
                    '戒烟社区',
                    Icons.people,
                    Colors.orange,
                    () => Get.toNamed('/community'),
                  ),
                  _buildFeatureCard(
                    '健康数据',
                    Icons.favorite,
                    Colors.red,
                    () => Get.toNamed('/health_data'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 戒烟小贴士
              const Text(
                '戒烟小贴士',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                '应对烟瘾小技巧',
                '当烟瘾来袭时，可以尝试深呼吸、喝水、嚼无糖口香糖或进行短暂的体育活动来分散注意力。',
                Icons.lightbulb_outline,
              ),
              const SizedBox(height: 10),
              _buildTipCard(
                '饮食调整建议',
                '增加水果蔬菜摄入，减少咖啡因和酒精消费，这些可能会触发吸烟欲望。',
                Icons.restaurant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 戒烟状态卡片
  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '已戒烟',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '7天',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.white54,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAchievementItem('节省金额', '¥350'),
                _buildAchievementItem('未吸烟支数', '140支'),
                _buildAchievementItem('延长寿命', '14小时'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 成就项目
  Widget _buildAchievementItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // 功能卡片
  Widget _buildFeatureCard(
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

  // 小贴士卡片
  Widget _buildTipCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF9C27B0)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
