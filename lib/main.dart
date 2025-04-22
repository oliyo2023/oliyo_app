import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oliyo_app/routes/app_pages.dart';
// 导入路由定义
import 'package:oliyo_app/controllers/app_controller.dart'; // 导入 AppController
import 'package:oliyo_app/services/pocketbase_service.dart'; // 导入 PocketBaseService
import 'package:logging/logging.dart';
import 'package:oliyo_app/services/time_service.dart'; // 导入 TimeService

final _logger = Logger('main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 配置日志
  Logger.root.level = Level.INFO; // 默认记录所有级别的日志
  Logger.root.onRecord.listen((record) {
    // 使用标准输出而不是print
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack trace: ${record.stackTrace}');
    }
  });

  await initServices(); // 等待服务初始化完成
  runApp(const MyApp());
}

/// 初始化所有服务
Future<void> initServices() async {
  _logger.info('Starting services...');
  // 初始化 SharedPreferences (确保在 PocketBaseService 之前)
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  _logger.info('SharedPreferences service started...');
  // 初始化 PocketBaseService
  await Get.putAsync(() async => await PocketBaseService().init());
  _logger.info('PocketBaseService service started...');
  _logger.info('All services started...');
  // 初始化 TimeService
  Get.put(TimeService()..init());
  _logger.info('TimeService service started...');
  // 初始化 AppController
  Get.put(AppController());
  _logger.info('AppController service started...');
}

class MyApp extends GetView<AppController> {
  // 修改继承
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 Obx 包裹 GetMaterialApp 以监听标题变化
    return Obx(
      () => GetMaterialApp(
        title: controller.appTitle.value, // 绑定到可观察的标题
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
          ), // 更新种子颜色为青色
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.initial, // 使用 AppPages 中定义的初始路由
        getPages: AppPages.routes,
      ),
    );
  }
}
