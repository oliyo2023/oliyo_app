import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/controllers/auth_controller.dart'; // 导入 AuthController
import 'package:logging/logging.dart'; // 导入 logging
import 'package:oliyo_app/routes/app_routes.dart'; // Import app_routes.dart
import 'package:oliyo_app/controllers/main_controller.dart'; // 导入 MainController

final Logger _logger = Logger('LoginController'); // 创建 logger 实例

class LoginController extends GetxController {
  final AuthController authController = Get.find<AuthController>(); // 获取 AuthController 实例
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() async {
    String email = emailController.text.trim(); // 获取邮箱并去除空格
    String password = passwordController.text.trim(); // 获取密码并去除空格

    // 邮箱验证
    if (!GetUtils.isEmail(email)) {
      _logger.warning('登录失败: 邮箱格式无效');
      Get.snackbar(
        '登录失败',
        '请输入有效的邮箱地址',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // 密码验证
    if (password.length < 6) {
      _logger.warning('登录失败: 密码长度不足6位');
      Get.snackbar(
        '登录失败',
        '密码长度不能少于6位',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(password) || !RegExp(r'[0-9]').hasMatch(password)) {
      _logger.warning('登录失败: 密码必须包含字母和数字');
      Get.snackbar(
        '登录失败',
        '密码必须包含字母和数字',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await authController.pbService.pbClient.collection('users').authWithPassword(email, password);
      _logger.info('登录成功: ${authController.pbService.pbClient.authStore.token}');
      // 登录成功后跳转到主页面并选择个人中心标签页
      Get.offNamed(Routes.main); // 跳转到主页面，并替换当前路由
      // 获取 MainController 实例并切换到个人中心标签页（索引为3）
      final MainController mainController = Get.find<MainController>();
      mainController.changePage(3);
    } on Exception catch (e) {
      _logger.warning('登录失败: ${e.toString()}');
      Get.snackbar(
        '登录失败',
        '登录失败: ${e.toString()}', // 显示更详细的错误信息
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
} 