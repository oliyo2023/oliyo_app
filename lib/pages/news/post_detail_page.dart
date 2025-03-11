import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:oliyo_app/controllers/post_detail_controller.dart';
import 'package:logging/logging.dart';

class PostDetailPage extends GetView<PostDetailController> {
  static final Logger _logger = Logger('PostDetailPage');
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    // 确保控制器已注册并加载文章数据
    Get.put(PostDetailController());
    controller.fetchPostById(postId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('文章详情'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          // 添加字体大小调整按钮
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () => controller.decreaseFontSize(),
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () => controller.increaseFontSize(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9C27B0)),
          );
        }

        if (controller.isError.value) {
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
                  onPressed: () => controller.fetchPostById(postId),
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

        final currentPost = controller.post.value;
        if (currentPost == null) {
          return const Center(child: Text('文章不存在'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 文章标题
                Text(
                  currentPost.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(height: 8),

                // 发布时间
                Text(
                  '发布时间：${DateFormat('yyyy-MM-dd HH:mm').format(currentPost.created)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // 分隔线
                const Divider(color: Color(0xFFE1BEE7)),
                const SizedBox(height: 16),

                // 文章图片（如果有）
                if (currentPost.imageUrl != null &&
                    currentPost.imageUrl!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(currentPost.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                // 文章内容 - 使用HtmlWidget渲染HTML内容
                if (currentPost.content != null)
                  Obx(
                    () => HtmlWidget(
                      currentPost.content!,
                      enableCaching: true,
                      textStyle: TextStyle(
                        fontSize: controller.fontSize.value,
                        height: 1.5,
                      ),
                      // 自定义渲染配置
                      customStylesBuilder: (element) {
                        if (element.localName == 'a') {
                          return {'color': '#9C27B0'}; // 设置链接颜色为紫色
                        }
                        return null;
                      },
                      // 处理图片宽度，使其适应屏幕
                      customWidgetBuilder: (element) {
                        return null;
                      },
                      // 渲染回调
                      onTapUrl: (url) {
                        // 这里可以处理URL点击事件，例如打开浏览器
                        _logger.info('点击了链接: $url');
                        return true;
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
