import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/news_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // 导入 kIsWeb
import 'package:oliyo_app/pages/news/post_detail_page.dart'; // 导入文章详情页面

class NewsPage extends GetView<NewsController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保 NewsController 已注册
    Get.put(NewsController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.posts.isEmpty && controller.isLoading.value) {
            // 首次加载显示加载指示器
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF9C27B0)),
            );
          }

          // 显示错误状态
          if (controller.isError.value && controller.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    '加载失败',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '网络连接出现问题',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
              onNotification: _handleScrollNotification, // 提取滚动处理逻辑
              child: ListView.builder(
                itemCount:
                    controller.posts.length +
                    // 为列表末尾的加载指示器/按钮/错误提示留出空间
                    (controller.hasMorePosts.value ||
                            controller.isLoading.value ||
                            controller.isError.value
                        ? 1 // 只需要一个额外项
                        : 0),
                itemBuilder: (context, index) {
                  // 检查是否是列表的最后一项（潜在的加载项）
                  if (index == controller.posts.length) {
                    return _buildListFooter(context); // 构建列表底部项
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
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // 点击文章导航到详情页面
                      Get.to(
                        () => PostDetailPage(postId: post.id),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  // 处理滚动通知，仅在非 Web 平台启用滚动加载
  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (!kIsWeb && // 关键判断：只在非 Web 环境下
        scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent - 50 &&
        controller.hasMorePosts.value &&
        !controller.isLoading.value &&
        !controller.isError.value) {
      // 使用 Future.microtask 避免在构建过程中调用 setState
      Future.microtask(() => controller.loadPosts());
    }
    return false; // 返回 false 表示继续冒泡通知
  }

  // 构建列表底部项 (加载指示器/加载更多按钮/错误重试)
  Widget _buildListFooter(BuildContext context) {
    if (kIsWeb) {
      // Web 环境下的逻辑
      if (controller.isLoading.value) {
        // Web 加载中
        return _buildLoadingIndicator();
      } else if (controller.isError.value) {
        // Web 加载错误
        return _buildErrorRetry();
      } else if (controller.hasMorePosts.value) {
        // Web 显示加载更多按钮
        return _buildLoadMoreButton(context);
      }
    } else {
      // 非 Web 环境下的逻辑
      if (controller.isLoading.value) {
        // 非 Web 加载中
        return _buildLoadingIndicator();
      } else if (controller.isError.value) {
        // 非 Web 加载错误
        return _buildErrorRetry();
      }
      // 非 Web 环境下，如果没有加载中或错误，且 hasMorePosts 为 true，
      // 则滚动监听器会处理加载，这里不需要显示任何内容。
      // 如果 hasMorePosts 为 false，itemCount 会少 1，不会到达这里。
    }
    // 如果没有更多数据且不在加载/错误状态，则不显示任何内容
    return const SizedBox.shrink();
  }

  // 构建加载指示器 Widget
  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF9C27B0))),
    );
  }

  // 构建错误重试 Widget
  Widget _buildErrorRetry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('加载失败，请重试', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: controller.retryLoading, // 点击重试
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

  // 构建 Web 平台的“加载更多”按钮 Widget
  Widget _buildLoadMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Center(
        child: ElevatedButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () => controller.loadPosts(), // 正在加载时禁用按钮
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9C27B0),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48), // 让按钮宽度填充
          ),
          child:
              controller.isLoading.value
                  ? const SizedBox(
                    // 加载时显示指示器
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                  : const Text('加载更多'),
        ),
      ),
    );
  }
}
