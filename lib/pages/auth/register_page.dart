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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '注册',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.emailController, // 使用控制器
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.passwordController, // 使用控制器
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.confirmPasswordController, // 使用控制器
                decoration: const InputDecoration(
                  labelText: '确认密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.register, // 使用控制器的方法，验证和错误提示在控制器中处理
                child: const Text('注册'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.back(); // 返回到登录页面
                },
                child: const Text('已有账号？去登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 