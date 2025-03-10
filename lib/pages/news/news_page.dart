import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/news_controller.dart';
import 'package:intl/intl.dart';

class NewsPage extends GetView<NewsController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保 NewsController 已注册
    Get.put(NewsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('新闻资讯'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.posts.isEmpty && controller.isLoading.value) {
          // 首次加载显示加载指示器
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF9C27B0),
            ),
          );
        }
        
        // 显示错误状态
        if (controller.isError.value && controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '网络连接出现问题',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.retryLoading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        if (controller.posts.isEmpty && !controller.isLoading.value) {
          // 没有文章时显示空状态
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.article_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  '暂无新闻',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.refreshPosts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('刷新'),
                ),
              ],
            ),
          );
        }
        
        // 显示文章列表
        return RefreshIndicator(
          onRefresh: controller.refreshPosts,
          color: const Color(0xFF9C27B0),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // 当滚动到底部且还有更多文章时，加载更多
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                  controller.hasMorePosts.value &&
                  !controller.isLoading.value &&
                  !controller.isError.value) {
                // 使用 Future.microtask 避免在构建过程中调用 setState
                Future.microtask(() => controller.loadPosts());
              }
              return false;
            },
            child: ListView.builder(
              itemCount: controller.posts.length + 
                (controller.hasMorePosts.value && controller.isLoading.value ? 1 : 0) +
                (controller.hasMorePosts.value && controller.isError.value ? 1 : 0),
              itemBuilder: (context, index) {
                // 如果到达列表底部且正在加载，显示加载指示器
                if (index == controller.posts.length && controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  );
                }
                
                // 如果到达列表底部且出现错误，显示重试按钮
                if (index == controller.posts.length && controller.isError.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            '加载更多失败',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: controller.retryLoading,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C27B0),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                // 显示文章列表项
                final post = controller.posts[index];
                return ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(post.created),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // 点击文章显示详情对话框
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(post.title),
                        content: SingleChildScrollView(
                          child: Text(post.content),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('关闭'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
} 