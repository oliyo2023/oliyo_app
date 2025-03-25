import 'package:get/get.dart';
import 'package:oliyo_app/controllers/auth_controller.dart'; // 导入 AuthController
// 导入路由
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:oliyo_app/routes/app_routes.dart';

final Logger _logger = Logger('ProfileController');

class ProfileController extends GetxController {
  final AuthController authController =
      Get.find<AuthController>(); // 获取 AuthController 实例

  void logout() async {
    try {
      authController.pbService.pbClient.authStore.clear(); // 清除认证信息
      _logger.info('退出登录成功');
      Get.offAllNamed(Routes.main); // 退出登录后跳转到首页，使用 offAllNamed 防止用户返回个人中心页面
    } catch (e) {
      final errorMsg = '退出登录失败: ${e.toString()}';
      _logger.warning(errorMsg);
      // 可以添加错误处理逻辑，例如显示错误提示
      Get.snackbar(
        '退出失败',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
