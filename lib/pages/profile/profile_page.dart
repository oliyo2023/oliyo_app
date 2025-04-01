import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart'; // 导入控制器
import '../../controllers/auth_controller.dart'; // 导入 AuthController 以获取用户信息

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController()); // 注册 ProfileController
    final AuthController authController =
        Get.find<AuthController>(); // 获取 AuthController 实例

    return Scaffold(
      // appBar: AppBar( // 可以选择性地添加 AppBar
      //   title: const Text('个人中心'),
      // ),
      body: SafeArea(
        // 使用 SafeArea 避免内容与系统 UI 重叠
        child: ListView(
          // 使用 ListView 方便扩展
          padding: const EdgeInsets.all(16.0), // 添加整体内边距
          children: [
            const SizedBox(height: 20),
            // 用户信息区域
            Column(
              children: [
                // Obx removed as the current CircleAvatar doesn't directly use observables
                CircleAvatar(
                  // 使用 Obx 监听用户头像变化 (Comment updated)
                  radius: 50,
                  // backgroundImage: NetworkImage(authController.user.value?.avatarUrl ?? ''), // 假设 AuthController 有 user 对象包含头像 URL
                  // backgroundColor: Colors.grey[200], // 头像加载时的背景色
                  // child: authController.currentUser.value?.getStringValue('avatar') == null // 假设头像字段名为 'avatar'
                  //     ? const Icon(Icons.person, size: 50, color: Colors.grey) // 默认图标
                  //     : null,
                  // 暂时使用占位符图标
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,

                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    // 使用 Obx 监听用户昵称变化
                    // authController.user.value?.nickname ?? '用户名', // 假设 AuthController 有 user 对象包含昵称
                    // 从 RecordModel 获取 username 字段
                    authController.currentUser.value?.getStringValue(
                          'username',
                        ) ??
                        '用户名',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 功能列表或设置项 (可以后续添加 ListTile 等)
            // const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('设置'),
            //   onTap: () {
            //     // 跳转到设置页面
            //   },
            // ),
            // const Divider(),

            // 退出登录按钮
            Center(
              // 将按钮居中放置，或使用 ListTile
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('退出登录'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  backgroundColor:
                      Theme.of(context).colorScheme.errorContainer, // 按钮文字颜色
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  controller.logout(); // 调用 ProfileController 中的退出登录方法
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
