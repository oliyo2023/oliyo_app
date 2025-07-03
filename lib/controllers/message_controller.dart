import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/models/message_model.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('MessageController');

class MessageController extends GetxController {
  // 延迟获取服务，避免初始化顺序问题
  PocketBaseService get pbService => Get.find<PocketBaseService>();
  AuthController get authController => Get.find<AuthController>();

  final messages = <Message>[].obs;
  final isLoading = false.obs;
  final hasMoreMessages = true.obs;
  final isError = false.obs;

  final TextEditingController messageInputController = TextEditingController();

  int page = 1;
  final int perPage = 20;
  int retryCount = 0;
  static const int maxRetries = 3;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  @override
  void onClose() {
    messageInputController.dispose();
    super.onClose();
  }

  // 加载消息列表
  Future<void> loadMessages({bool refresh = false}) async {
    if (isLoading.value) return;

    // 检查用户是否已登录
    if (!authController.pbService.pbClient.authStore.isValid) {
      _logger.warning('加载消息失败: 用户未登录');
      Get.snackbar(
        '加载失败',
        '请先登录后查看消息',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (refresh) {
      page = 1;
      hasMoreMessages.value = true;
      isError.value = false;
      retryCount = 0;
    }

    if (!hasMoreMessages.value) return;

    isLoading.value = true;
    isError.value = false;

    try {
      _logger.info('开始加载第 $page 页消息，每页 $perPage 条');

      // 获取当前用户ID
      final currentUserId =
          authController.pbService.pbClient.authStore.model.id;

      // 查询消息 - 包括发送和接收的消息
      final resultList = await pbService.pbClient
          .collection('messages')
          .getList(
            page: page,
            perPage: perPage,
            filter: 'sender = "$currentUserId" || receiver = "$currentUserId"',
            sort: '-created',
          );

      final newMessages =
          resultList.items
              .map((item) => Message.fromJson(item.toJson()))
              .toList();

      if (refresh) {
        messages.clear();
      }

      messages.addAll(newMessages);

      // 检查是否还有更多消息
      hasMoreMessages.value = newMessages.length >= perPage;

      // 增加页码，为下次加载做准备
      if (hasMoreMessages.value) {
        page++;
      }

      retryCount = 0;
      _logger.info('加载了 ${newMessages.length} 条消息，总共 ${messages.length} 条');
    } catch (e) {
      final errorMsg = '加载消息失败: $e';
      _logger.warning(errorMsg);

      isError.value = true;

      if (e.toString().contains('Connection closed') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException')) {
        retryCount++;
        if (retryCount <= maxRetries) {
          _logger.info('网络错误，尝试第 $retryCount 次重试...');
          Future.delayed(Duration(seconds: retryCount), () {
            loadMessages(refresh: false);
          });
          return;
        }
      }

      Get.snackbar(
        '加载失败',
        '无法加载消息列表，请检查网络连接后重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 发送消息
  Future<void> sendMessage(String receiverId) async {
    if (messageInputController.text.trim().isEmpty) {
      return;
    }

    // 检查用户是否已登录
    if (!authController.pbService.pbClient.authStore.isValid) {
      _logger.warning('发送消息失败: 用户未登录');
      Get.snackbar(
        '发送失败',
        '请先登录后发送消息',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final content = messageInputController.text.trim();
    messageInputController.clear();

    try {
      final currentUserId =
          authController.pbService.pbClient.authStore.model.id;

      final record = await pbService.pbClient
          .collection('messages')
          .create(
            body: {
              'content': content,
              'sender': currentUserId,
              'receiver': receiverId,
              'is_read': false,
            },
          );

      // 创建新消息对象并添加到列表顶部
      final newMessage = Message.fromJson(record.toJson());
      messages.insert(0, newMessage);

      _logger.info('消息发送成功: ${record.id}');
    } catch (e) {
      final errorMsg = '发送消息失败: $e';
      _logger.warning(errorMsg);

      Get.snackbar(
        '发送失败',
        '无法发送消息，请稍后重试',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // 标记消息为已读
  Future<void> markAsRead(String messageId) async {
    try {
      await pbService.pbClient
          .collection('messages')
          .update(messageId, body: {'is_read': true});

      // 更新本地消息状态
      final index = messages.indexWhere((message) => message.id == messageId);
      if (index != -1) {
        final updatedMessage = Message(
          id: messages[index].id,
          content: messages[index].content,
          senderId: messages[index].senderId,
          receiverId: messages[index].receiverId,
          created: messages[index].created,
          isRead: true,
        );
        messages[index] = updatedMessage;
      }

      _logger.info('消息已标记为已读: $messageId');
    } catch (e) {
      _logger.warning('标记消息已读失败: $e');
    }
  }

  // 刷新消息列表
  Future<void> refreshMessages() async {
    return loadMessages(refresh: true);
  }

  // 重试加载
  void retryLoading() {
    retryCount = 0;
    loadMessages(refresh: false);
  }
}
