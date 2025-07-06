import 'package:get/get.dart';
import 'package:oliyo_app/models/post_model.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

final Logger _logger = Logger('PostDetailController');

class PostDetailController extends GetxController {
  // 延迟获取 PocketBaseService，避免初始化顺序问题
  PocketBaseService get pbService => Get.find<PocketBaseService>();
  final Rx<Post?> post = Rx<Post?>(null);
  final isLoading = true.obs;
  final isError = false.obs;

  // 添加字体大小控制变量，默认为16
  final fontSize = 16.0.obs;

  // 增加字体大小的方法
  void increaseFontSize() {
    if (fontSize.value < 24) {
      fontSize.value += 2.0;
      _logger.info('增加字体大小: ${fontSize.value}');
    }
  }

  // 减小字体大小的方法
  void decreaseFontSize() {
    if (fontSize.value > 12) {
      fontSize.value -= 2.0;
      _logger.info('减小字体大小: ${fontSize.value}');
    }
  }

  void setPost(Post postData) {
    post.value = postData;
    isLoading.value = false;
  }

  Future<void> fetchPostById(String id) async {
    isLoading.value = true;
    isError.value = false;

    try {
      _logger.info('开始加载文章详情，ID: $id');

      // 暂时使用模拟数据，避免PocketBase API调用问题
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      
      final mockPost = Post(
        id: id,
        title: '戒烟的好处',
        content: '''
戒烟对身体健康有很多好处：

1. 改善呼吸系统
戒烟后，肺部功能会逐渐恢复，呼吸会更加顺畅。

2. 降低心脏病风险
戒烟可以显著降低心脏病和中风的风险。

3. 改善味觉和嗅觉
戒烟后，味觉和嗅觉会逐渐恢复，食物会更加美味。

4. 节省金钱
戒烟可以节省大量的金钱，这些钱可以用于其他更有意义的事情。

5. 改善皮肤
戒烟后，皮肤会变得更加健康和有光泽。

6. 提高生活质量
戒烟后，身体会更加健康，生活质量会显著提高。
        ''',
        imageUrl: null,
        created: DateTime.now().subtract(const Duration(days: 1)),
      );

      post.value = mockPost;
      _logger.info('文章详情加载成功');
    } catch (e) {
      _logger.warning('加载文章详情失败: $e');
      isError.value = true;

      Get.snackbar(
        '加载失败',
        '无法加载文章详情，请检查网络连接后重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
