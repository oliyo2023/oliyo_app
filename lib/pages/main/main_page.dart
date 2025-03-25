import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/controllers/main_controller.dart';
import 'package:oliyo_app/pages/home/home_page.dart';
import 'package:oliyo_app/pages/news/news_page.dart';
import 'package:oliyo_app/pages/discover/discover_page.dart';
import 'package:oliyo_app/pages/profile/profile_page.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:oliyo_app/routes/app_routes.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: const [
          HomePage(),
          NewsPage(),
          DiscoverPage(),
          ProfilePage(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (index == 3) {
            if (authController.pbService.pbClient.authStore.isValid) {
              controller.changePage(index);
            } else {
              Get.toNamed(Routes.login);
            }
          } else {
            controller.changePage(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: '新闻',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      )),
    );
  }
} 