import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/register_controller.dart'; // 导入控制器

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注册 RegisterController
    Get.put(RegisterController());

    return Scaffold(
      body: Container(
        // 使用紫色渐变背景，与登录页面保持一致
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9C27B0), // 深紫色
              Color(0xFFE1BEE7), // 浅紫色
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 返回按钮
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // 注册表单
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // 应用图标或Logo
                            const Icon(
                              Icons.person_add,
                              size: 80,
                              color: Color(0xFF9C27B0),
                            ),
                            const SizedBox(height: 24),
                            // 标题
                            const Text(
                              '创建账号',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9C27B0),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // 邮箱输入框
                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: '邮箱',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color(0xFF9C27B0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF9C27B0),
                                    width: 2,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            // 密码输入框
                            TextField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                labelText: '密码',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF9C27B0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF9C27B0),
                                    width: 2,
                                  ),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            // 确认密码输入框
                            TextField(
                              controller: controller.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: '确认密码',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF9C27B0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF9C27B0),
                                    width: 2,
                                  ),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            // 注册按钮
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9C27B0),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  '注册',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 登录链接
                            TextButton(
                              onPressed: () {
                                Get.back(); // 返回到登录页面
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF9C27B0),
                              ),
                              child: const Text(
                                '已有账号？去登录',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
