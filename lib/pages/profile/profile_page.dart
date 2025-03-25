import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart'; // 导入控制器

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController()); // 注册 ProfileController

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '欢迎来到个人中心',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // 在这里添加退出登录按钮
            ElevatedButton(
              onPressed: () {
                controller.logout(); // 调用 ProfileController 中的退出登录方法
              },
              child: const Text('退出登录'),
            ),
          ],
        ),
      ),
    );
  }
} 