import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/models/post_model.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('NewsController');

class NewsController extends GetxController {
  final PocketBaseService pbService = Get.find<PocketBaseService>();
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
      
      final resultList = await pbService.pbClient.collection('posts').getList(
        page: page,
        perPage: perPage,
        sort: '-created', // 按创建时间降序排序
      );
      
      final newPosts = resultList.items.map((item) => Post.fromJson(item.toJson())).toList();
      
      if (refresh) {
        posts.clear();
      }
      
      posts.addAll(newPosts);
      
      // 检查是否还有更多文章
      hasMorePosts.value = newPosts.length >= perPage;
      
      // 增加页码，为下次加载做准备
      if (hasMorePosts.value) {
        page++;
      }
      
      retryCount = 0;
      _logger.info('加载了 ${newPosts.length} 篇文章，总共 ${posts.length} 篇');
    } catch (e) {
      final errorMsg = '加载文章失败: $e';
      _logger.warning(errorMsg);
      
      isError.value = true;
      
      if (e.toString().contains('Connection closed') || 
          e.toString().contains('timeout') || 
          e.toString().contains('SocketException')) {
        
        retryCount++;
        if (retryCount <= maxRetries) {
          _logger.info('网络错误，尝试第 $retryCount 次重试...');
          Future.delayed(Duration(seconds: retryCount), () {
            loadPosts(refresh: false);
          });
          return;
        }
      }
      
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
  
  void retryLoading() {
    retryCount = 0;
    loadPosts(refresh: false);
  }
} 