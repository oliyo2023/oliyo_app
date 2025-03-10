import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart'; // 导入控制器

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('首页内容'),
      ),
    );
  }
} 