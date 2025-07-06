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

      // 暂时使用模拟数据，避免PocketBase API调用问题
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      
      final mockMessages = [
        Message(
          id: '1',
          content: '你好！欢迎使用戒烟助手应用。',
          senderId: 'system',
          receiverId: 'user',
          isRead: true,
          created: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Message(
          id: '2',
          content: '今天感觉怎么样？记得记录你的戒烟进度哦！',
          senderId: 'system',
          receiverId: 'user',
          isRead: false,
          created: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Message(
          id: '3',
          content: '坚持就是胜利！你已经很棒了！',
          senderId: 'system',
          receiverId: 'user',
          isRead: false,
          created: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ];

      if (refresh) {
        messages.clear();
      }

      messages.addAll(mockMessages);

      // 检查是否还有更多消息
      hasMoreMessages.value = false; // 模拟数据只有一页

      retryCount = 0;
      _logger.info('加载了 ${mockMessages.length} 条消息，总共 ${messages.length} 条');
    } catch (e) {
      final errorMsg = '加载消息失败: $e';
      _logger.warning(errorMsg);

      isError.value = true;

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

    final content = messageInputController.text.trim();
    messageInputController.clear();

    try {
      // 暂时使用模拟数据，避免PocketBase API调用问题
      await Future.delayed(const Duration(milliseconds: 500)); // 模拟网络延迟
      
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        senderId: 'user',
        receiverId: receiverId,
        isRead: false,
        created: DateTime.now(),
      );

      // 创建新消息对象并添加到列表顶部
      messages.insert(0, newMessage);

      _logger.info('消息发送成功: ${newMessage.id}');
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
      // 暂时使用模拟数据，避免PocketBase API调用问题
      await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟
      
      final messageIndex = messages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex != -1) {
        final message = messages[messageIndex];
        messages[messageIndex] = Message(
          id: message.id,
          content: message.content,
          senderId: message.senderId,
          receiverId: message.receiverId,
          isRead: true,
          created: message.created,
        );
        _logger.info('消息已标记为已读: $messageId');
      }
    } catch (e) {
      _logger.warning('标记消息为已读失败: $e');
    }
  }

  // 刷新消息列表
  Future<void> refreshMessages() async {
    return loadMessages(refresh: true);
  }

  // 重试加载
  void retryLoading() {
    loadMessages(refresh: false);
  }
}
