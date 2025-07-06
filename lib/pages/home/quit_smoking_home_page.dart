import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/constants/app_constants.dart';

class QuitSmokingHomePage extends StatefulWidget {
  const QuitSmokingHomePage({super.key});

  @override
  State<QuitSmokingHomePage> createState() => _QuitSmokingHomePageState();
}

class _QuitSmokingHomePageState extends State<QuitSmokingHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // 自定义AppBar
          _buildSliverAppBar(),
          
          // 主要内容
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户戒烟状态卡片
                      _buildStatusCard(),
                      const SizedBox(height: 24),

                      // 快速操作区域
                      _buildQuickActions(),
                      const SizedBox(height: 24),

                      // 主要功能区域
                      _buildMainFeatures(),
                      const SizedBox(height: 24),

                      // 今日目标
                      _buildTodayGoals(),
                      const SizedBox(height: 24),

                      // 戒烟小贴士
                      _buildTipsSection(),
                      const SizedBox(height: 24),

                      // 成就徽章
                      _buildAchievements(),
                      const SizedBox(height: 24),

                      // 社区动态
                      _buildCommunityUpdates(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // 自定义SliverAppBar
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'AI戒烟助手',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF7BB3F0),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            Get.snackbar(
              '通知',
              '暂无新通知',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.white,
              colorText: Colors.black87,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Get.toNamed('/profile'),
        ),
      ],
    );
  }

  // 戒烟状态卡片
  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '戒烟进度',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '7天',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAchievementItem('节省金额', '¥350', Icons.savings),
                _buildAchievementItem('未吸烟支数', '140支', Icons.smoke_free),
                _buildAchievementItem('延长寿命', '14小时', Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 成就项目
  Widget _buildAchievementItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // 快速操作区域
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快速操作',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                '记录烟瘾',
                Icons.add_circle_outline,
                const Color(0xFFE57373),
                () => _showCravingDialog(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                '查看进度',
                Icons.trending_up,
                const Color(0xFF81C784),
                () => Get.toNamed('/health_data'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 快速操作卡片
  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 主要功能区域
  Widget _buildMainFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '戒烟工具',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              '制定戒烟计划',
              Icons.calendar_today,
              const Color(0xFF4FC3F7),
              '个性化戒烟方案',
              () => Get.toNamed('/smoking_plan'),
            ),
            _buildFeatureCard(
              '资金节约计算',
              Icons.savings,
              const Color(0xFF66BB6A),
              '查看节省金额',
              () => Get.toNamed('/savings_calculator'),
            ),
            _buildFeatureCard(
              '戒烟社区',
              Icons.people,
              const Color(0xFFFFB74D),
              '与伙伴交流',
              () => Get.toNamed('/community'),
            ),
            _buildFeatureCard(
              '健康数据',
              Icons.favorite,
              const Color(0xFFF06292),
              '身体恢复情况',
              () => Get.toNamed('/health_data'),
            ),
          ],
        ),
      ],
    );
  }

  // 功能卡片
  Widget _buildFeatureCard(String title, IconData icon, Color color, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 今日目标
  Widget _buildTodayGoals() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: Color(0xFF4A90E2)),
              const SizedBox(width: 8),
              const Text(
                '今日目标',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '3/5 完成',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGoalItem('喝水8杯', true, 0.8),
          const SizedBox(height: 12),
          _buildGoalItem('运动30分钟', true, 1.0),
          const SizedBox(height: 12),
          _buildGoalItem('深呼吸练习', true, 1.0),
          const SizedBox(height: 12),
          _buildGoalItem('记录心情', false, 0.0),
          const SizedBox(height: 12),
          _buildGoalItem('阅读戒烟文章', false, 0.0),
        ],
      ),
    );
  }

  // 目标项目
  Widget _buildGoalItem(String title, bool completed, double progress) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: completed ? Colors.black87 : Colors.grey[600],
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              if (!completed) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                  minHeight: 4,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // 戒烟小贴士
  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '戒烟小贴士',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildTipCard(
          '应对烟瘾小技巧',
          '当烟瘾来袭时，可以尝试深呼吸、喝水、嚼无糖口香糖或进行短暂的体育活动来分散注意力。',
          Icons.lightbulb_outline,
          const Color(0xFFFFB74D),
        ),
        const SizedBox(height: 12),
        _buildTipCard(
          '饮食调整建议',
          '增加水果蔬菜摄入，减少咖啡因和酒精消费，这些可能会触发吸烟欲望。',
          Icons.restaurant,
          const Color(0xFF81C784),
        ),
        const SizedBox(height: 12),
        _buildTipCard(
          '心理支持',
          '记住戒烟是一个过程，不要因为偶尔的挫折而放弃。每一次坚持都是胜利！',
          Icons.psychology,
          const Color(0xFF64B5F6),
        ),
      ],
    );
  }

  // 小贴士卡片
  Widget _buildTipCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 成就徽章
  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '成就徽章',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAchievementBadge('7天坚持', Icons.celebration, true),
              const SizedBox(width: 12),
              _buildAchievementBadge('节省100元', Icons.savings, true),
              const SizedBox(width: 12),
              _buildAchievementBadge('30天目标', Icons.flag, false),
              const SizedBox(width: 12),
              _buildAchievementBadge('健康达人', Icons.favorite, false),
              const SizedBox(width: 12),
              _buildAchievementBadge('社区活跃', Icons.people, false),
            ],
          ),
        ),
      ],
    );
  }

  // 成就徽章
  Widget _buildAchievementBadge(String title, IconData icon, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: unlocked ? const Color(0xFF4A90E2) : Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
            boxShadow: unlocked ? [
              BoxShadow(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: Icon(
            icon,
            color: unlocked ? Colors.white : Colors.grey[500],
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: unlocked ? Colors.black87 : Colors.grey[500],
            fontWeight: unlocked ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // 社区动态
  Widget _buildCommunityUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '社区动态',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Get.toNamed('/community'),
              child: const Text('查看更多'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCommunityItem(
                '张三',
                '今天是我戒烟的第15天，感觉呼吸更顺畅了！',
                '2小时前',
                Icons.celebration,
              ),
              const Divider(),
              _buildCommunityItem(
                '李四',
                '分享一个戒烟小技巧：用薄荷糖代替香烟',
                '4小时前',
                Icons.lightbulb_outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 社区动态项目
  Widget _buildCommunityItem(String name, String content, String time, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
          child: Text(
            name[0],
            style: const TextStyle(
              color: Color(0xFF4A90E2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 浮动操作按钮
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showCravingDialog(),
      backgroundColor: const Color(0xFF4A90E2),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        '记录烟瘾',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // 显示烟瘾记录对话框
  void _showCravingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('记录烟瘾'),
        content: const Text('您想要记录一次烟瘾吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                '记录成功',
                '已记录一次烟瘾，继续保持！',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}
