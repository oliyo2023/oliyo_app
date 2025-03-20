import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/message_controller.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:oliyo_app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:oliyo_app/models/message_model.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保 MessageController 已注册
    Get.put(MessageController());

    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的消息'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // 检查用户是否已登录
        if (!authController.pbService.pbClient.authStore.isValid) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  '请先登录',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('去登录'),
                ),
              ],
            ),
          );
        }

        if (controller.messages.isEmpty && controller.isLoading.value) {
          // 首次加载显示加载指示器
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9C27B0)),
          );
        }

        // 显示错误状态
        if (controller.isError.value && controller.messages.isEmpty) {
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

        if (controller.messages.isEmpty && !controller.isLoading.value) {
          // 没有消息时显示空状态
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  '暂无消息',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.refreshMessages,
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

        // 显示消息列表
        return RefreshIndicator(
          onRefresh: controller.refreshMessages,
          color: const Color(0xFF9C27B0),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // 当滚动接近底部且还有更多消息时，加载更多
              if (scrollInfo.metrics.pixels >
                      scrollInfo.metrics.maxScrollExtent - 50 &&
                  controller.hasMoreMessages.value &&
                  !controller.isLoading.value &&
                  !controller.isError.value) {
                // 使用 Future.microtask 避免在构建过程中调用 setState
                Future.microtask(() => controller.loadMessages());
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  controller.messages.length +
                  (controller.hasMoreMessages.value &&
                          controller.isLoading.value
                      ? 1
                      : 0) +
                  (controller.hasMoreMessages.value && controller.isError.value
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                // 如果到达列表底部且正在加载，显示加载指示器
                if (index == controller.messages.length &&
                    controller.isLoading.value) {
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
                if (index == controller.messages.length &&
                    controller.isError.value) {
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

                // 显示消息列表项
                final message = controller.messages[index];
                final currentUserId =
                    authController.pbService.pbClient.authStore.model.id;
                final isOutgoing = message.senderId == currentUserId;

                return ListTile(
                  title: Text(
                    message.content,
                    style: TextStyle(
                      fontWeight:
                          isOutgoing || message.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(message.created),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  leading: CircleAvatar(
                    backgroundColor:
                        isOutgoing ? Colors.blue : const Color(0xFF9C27B0),
                    child: Icon(
                      isOutgoing ? Icons.person : Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  trailing:
                      isOutgoing
                          ? Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            color: message.isRead ? Colors.green : Colors.grey,
                            size: 16,
                          )
                          : null,
                  onTap: () {
                    // 点击消息导航到详情页面
                    Get.to(
                      () => MessageDetailPage(message: message),
                      transition: Transition.rightToLeft,
                    );

                    // 如果是收到的消息且未读，标记为已读
                    if (!isOutgoing && !message.isRead) {
                      controller.markAsRead(message.id);
                    }
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

// 消息详情页面
class MessageDetailPage extends StatelessWidget {
  final Message message;

  const MessageDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.find<MessageController>();
    final AuthController authController = Get.find<AuthController>();
    final currentUserId = authController.pbService.pbClient.authStore.model.id;
    final isOutgoing = message.senderId == currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOutgoing ? '发送的消息' : '收到的消息'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isOutgoing
                              ? '发送给：${message.receiverId}'
                              : '来自：${message.senderId}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'yyyy-MM-dd HH:mm:ss',
                          ).format(message.created),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(message.content, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    if (isOutgoing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            color: message.isRead ? Colors.green : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            message.isRead ? '已读' : '未读',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  message.isRead ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (!isOutgoing)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageInputController,
                        decoration: InputDecoration(
                          hintText: '回复消息...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () {
                        controller.sendMessage(message.senderId);
                        // 发送后返回上一页
                        Get.back();
                      },
                      backgroundColor: const Color(0xFF9C27B0),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
