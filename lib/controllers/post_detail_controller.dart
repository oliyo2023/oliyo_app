import 'package:get/get.dart';
import 'package:oliyo_app/models/post_model.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

final Logger _logger = Logger('PostDetailController');

class PostDetailController extends GetxController {
  final PocketBaseService pbService = Get.find<PocketBaseService>();
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
      
      final record = await pbService.pbClient
          .collection('posts')
          .getOne(id, fields: "id,title,content,image,created");
      
      post.value = Post.fromJson(record.toJson());
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