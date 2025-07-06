import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oliyo_app/constants/app_constants.dart';

/// 通用工具类
class Helpers {
  /// 显示成功消息
  static void showSuccess(String message) {
    Get.snackbar(
      '成功',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(AppConstants.successColorValue),
      colorText: Colors.white,
      duration: AppConstants.mediumAnimationDuration,
    );
  }

  /// 显示错误消息
  static void showError(String message) {
    Get.snackbar(
      '错误',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(AppConstants.errorColorValue),
      colorText: Colors.white,
      duration: AppConstants.mediumAnimationDuration,
    );
  }

  /// 显示警告消息
  static void showWarning(String message) {
    Get.snackbar(
      '警告',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(AppConstants.warningColorValue),
      colorText: Colors.white,
      duration: AppConstants.mediumAnimationDuration,
    );
  }

  /// 显示确认对话框
  static Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = '确认',
    String cancelText = '取消',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 显示加载对话框
  static void showLoading([String message = '加载中...']) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(message),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// 隐藏加载对话框
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// 格式化日期
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  /// 格式化时间
  static String formatTime(DateTime time, {String format = 'HH:mm:ss'}) {
    return DateFormat(format).format(time);
  }

  /// 格式化日期时间
  static String formatDateTime(DateTime dateTime, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(dateTime);
  }

  /// 获取相对时间描述
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  /// 验证邮箱格式
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// 验证手机号格式（中国大陆）
  static bool isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  /// 验证密码强度
  static bool isStrongPassword(String password) {
    // 至少8位，包含大小写字母和数字
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$').hasMatch(password);
  }

  /// 获取密码强度等级
  static int getPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;
    if (RegExp(r'[@$!%*?&]').hasMatch(password)) strength++;
    
    return strength;
  }

  /// 获取密码强度描述
  static String getPasswordStrengthText(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 0:
      case 1:
        return '很弱';
      case 2:
        return '弱';
      case 3:
        return '中等';
      case 4:
        return '强';
      case 5:
        return '很强';
      default:
        return '未知';
    }
  }

  /// 获取密码强度颜色
  static Color getPasswordStrengthColor(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 0:
      case 1:
        return const Color(AppConstants.errorColorValue);
      case 2:
        return const Color(AppConstants.warningColorValue);
      case 3:
        return Colors.orange;
      case 4:
        return Colors.blue;
      case 5:
        return const Color(AppConstants.successColorValue);
      default:
        return Colors.grey;
    }
  }

  /// 复制到剪贴板
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSuccess('已复制到剪贴板');
  }

  /// 获取屏幕尺寸
  static Size getScreenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  /// 获取屏幕宽度
  static double getScreenWidth() {
    return getScreenSize().width;
  }

  /// 获取屏幕高度
  static double getScreenHeight() {
    return getScreenSize().height;
  }

  /// 检查是否为平板设备
  static bool isTablet() {
    return getScreenWidth() > 600;
  }

  /// 检查是否为手机设备
  static bool isPhone() {
    return getScreenWidth() <= 600;
  }

  /// 安全区域高度
  static double getSafeAreaHeight() {
    return MediaQuery.of(Get.context!).padding.top + MediaQuery.of(Get.context!).padding.bottom;
  }

  /// 状态栏高度
  static double getStatusBarHeight() {
    return MediaQuery.of(Get.context!).padding.top;
  }

  /// 底部安全区域高度
  static double getBottomSafeAreaHeight() {
    return MediaQuery.of(Get.context!).padding.bottom;
  }
} 