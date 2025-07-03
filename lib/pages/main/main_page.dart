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
    // 安全地获取 AuthController，如果不存在则返回 null
    final AuthController? authController =
        Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomePage(),
            NewsPage(),
            DiscoverPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            if (index == 3) {
              // 检查用户是否已登录，如果 authController 不可用则默认未登录
              final isLoggedIn =
                  authController?.pbService.pbClient.authStore.isValid ?? false;
              if (isLoggedIn) {
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: '新闻'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: '发现'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
          ],
        ),
      ),
    );
  }
}
