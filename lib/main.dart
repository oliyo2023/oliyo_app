import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oliyo_app/routes/app_pages.dart';
import 'package:oliyo_app/services/pocketbase_service.dart'; // 导入 PocketBaseService
import 'package:logging/logging.dart';

final _logger = Logger('main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 配置日志
  Logger.root.level = Level.ALL; // 默认记录所有级别的日志
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
