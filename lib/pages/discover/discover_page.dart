import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/discover_controller.dart'; // 导入控制器

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('发现页面内容'),
      ),
    );
  }
} 