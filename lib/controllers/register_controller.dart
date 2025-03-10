import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/controllers/auth_controller.dart'; // 导入 AuthController
import 'package:logging/logging.dart'; // 导入 logging

final Logger _logger = Logger('RegisterController'); // 创建 logger 实例

class RegisterController extends GetxController {
  final AuthController authController = Get.find<AuthController>(); // 获取 AuthController 实例
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void register() async {
    String email = emailController.text.trim(); // 获取邮箱并去除空格
    String password = passwordController.text.trim(); // 获取密码并去除空格
    String confirmPassword = confirmPasswordController.text.trim(); // 获取确认密码并去除空格

    // 邮箱验证
    if (!GetUtils.isEmail(email)) {
      _logger.warning('注册失败: 邮箱格式无效');
      Get.snackbar(
        '注册失败',
        '请输入有效的邮箱地址',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // 密码验证
    if (password.length < 6) {
      _logger.warning('注册失败: 密码长度不足6位');
      Get.snackbar(
        '注册失败',
        '密码长度不能少于6位',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(password) || !RegExp(r'[0-9]').hasMatch(password)) {
      _logger.warning('注册失败: 密码必须包含字母和数字');
      Get.snackbar(
        '注册失败',
        '密码必须包含字母和数字',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      _logger.warning('注册失败: 两次密码输入不一致');
      Get.snackbar(
        '注册失败',
        '两次密码输入不一致',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final record = await authController.pbService.pbClient.collection('users').create(body: {
        "email": email,
        "password": password,
        "passwordConfirm": confirmPassword,
      });
      _logger.info('注册成功: ${record.id}');
      // 注册成功后跳转到登录页面或自动登录
      Get.back(); // 返回到登录页面
    } on Exception catch (e) {
      _logger.warning('注册失败: ${e.toString()}');
      Get.snackbar(
        '注册失败',
        '注册失败: ${e.toString()}', // 显示更详细的错误信息
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
} 