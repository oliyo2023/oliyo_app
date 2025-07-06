import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/models/post_model.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('NewsController');

class NewsController extends GetxController {
  // 延迟获取 PocketBaseService，避免初始化顺序问题
  PocketBaseService get pbService => Get.find<PocketBaseService>();
  final posts = <Post>[].obs;
  final isLoading = false.obs;
  final hasMorePosts = true.obs;
  final isError = false.obs;

  int page = 1;
  final int perPage = 10;
  int retryCount = 0;
  static const int maxRetries = 3;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // 加载文章列表
  Future<void> loadPosts({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      page = 1;
      hasMorePosts.value = true;
      isError.value = false;
      retryCount = 0;
    }

    if (!hasMorePosts.value) return;

    isLoading.value = true;
    isError.value = false;

    try {
      _logger.info('开始加载第 $page 页文章，每页 $perPage 篇');

      // 暂时使用模拟数据，避免PocketBase API调用问题
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      
      final mockPosts = [
        Post(
          id: '1',
          title: '戒烟的好处',
          content: '戒烟对身体健康有很多好处...',
          imageUrl: null,
          created: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Post(
          id: '2',
          title: '健康生活方式指南',
          content: '保持健康的生活方式对每个人都很重要...',
          imageUrl: null,
          created: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Post(
          id: '3',
          title: '戒烟成功案例分享',
          content: '很多用户通过我们的应用成功戒烟...',
          imageUrl: null,
          created: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      if (refresh) {
        posts.clear();
      }

      posts.addAll(mockPosts);

      // 检查是否还有更多文章
      hasMorePosts.value = false; // 模拟数据只有一页

      retryCount = 0;
      _logger.info('加载了 ${mockPosts.length} 篇文章，总共 ${posts.length} 篇');
    } catch (e) {
      final errorMsg = '加载文章失败: $e';
      _logger.warning(errorMsg);

      isError.value = true;

      Get.snackbar(
        '加载失败',
        '无法加载文章列表，请检查网络连接后重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 刷新文章列表
  Future<void> refreshPosts() async {
    return loadPosts(refresh: true);
  }

  // 重试加载
  void retryLoading() {
    loadPosts(refresh: false);
  }
}
