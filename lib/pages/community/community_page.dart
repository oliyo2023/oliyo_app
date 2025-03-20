import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('戒烟社区'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 发布新帖子
              _showNewPostDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 社区介绍卡片
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '戒烟社区',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '在这里，您可以与其他戒烟者分享经验、获取支持和建议。一起加油，共同战胜烟瘾！',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 热门话题
              const Text(
                '热门话题',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTopicList(),

              const SizedBox(height: 24),

              // 最新帖子
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '最新帖子',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // 查看更多帖子
                    },
                    child: const Text('查看更多'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPostList(),
            ],
          ),
        ),
      ),
    );
  }

  // 热门话题列表
  Widget _buildTopicList() {
    final topics = [
      {'name': '戒烟第一周', 'count': 128},
      {'name': '应对烟瘾', 'count': 85},
      {'name': '戒烟成功经验', 'count': 76},
      {'name': '复吸怎么办', 'count': 64},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                // 进入话题详情
              },
              icon: const Icon(Icons.tag, size: 16),
              label: Text(
                '${topics[index]['name']} (${topics[index]['count']})',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF9C27B0),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE1BEE7)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 帖子列表
  Widget _buildPostList() {
    final posts = [
      {
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
        'username': '戒烟勇士',
        'time': '2小时前',
        'content': '今天是我戒烟的第30天！感觉呼吸更顺畅了，也不再总是想着抽烟。感谢社区的支持！',
        'likes': 24,
        'comments': 8,
      },
      {
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
        'username': '新手戒烟',
        'time': '昨天',
        'content': '刚开始戒烟的第3天，烟瘾特别大，有什么好方法缓解吗？',
        'likes': 12,
        'comments': 15,
      },
      {
        'avatar': 'https://randomuser.me/api/portraits/men/62.jpg',
        'username': '健康达人',
        'time': '3天前',
        'content': '分享一下我的戒烟经验：1.找到替代活动 2.避开吸烟场景 3.使用尼古丁贴片 4.寻求家人支持',
        'likes': 56,
        'comments': 23,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostItem(post);
      },
    );
  }

  // 帖子项
  Widget _buildPostItem(Map<String, dynamic> post) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post['avatar']),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post['time'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 帖子内容
            Text(post['content']),
            const SizedBox(height: 12),
            // 互动按钮
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_outlined, size: 18),
                  onPressed: () {},
                ),
                Text('${post['likes']}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  onPressed: () {},
                ),
                Text('${post['comments']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 发布新帖子对话框
  void _showNewPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('发布新帖子'),
            content: TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '分享您的戒烟经验或提问...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    '成功',
                    '帖子已发布',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                ),
                child: const Text('发布'),
              ),
            ],
          ),
    );
  }
}
