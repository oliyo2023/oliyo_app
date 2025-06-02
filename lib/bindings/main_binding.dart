import 'package:get/get.dart';
import 'package:oliyo_app/controllers/main_controller.dart';
import 'package:oliyo_app/controllers/home_controller.dart';
import 'package:oliyo_app/controllers/news_controller.dart';
import 'package:oliyo_app/controllers/discover_controller.dart';
import 'package:oliyo_app/controllers/profile_controller.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:oliyo_app/services/time_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController(), fenix: true); // 注册 MainController
    Get.lazyPut(() => HomeController(), fenix: true); // 注册 HomeController
    Get.lazyPut(() => NewsController(), fenix: true); // 注册 NewsController
    Get.lazyPut(
      () => DiscoverController(),
      fenix: true,
    ); // 注册 DiscoverController
    Get.lazyPut(() => ProfileController(), fenix: true); // 注册 ProfileController
    Get.lazyPut(
      () => AuthController(),
      fenix: true,
    ); // Register AuthController in MainBinding
    Get.lazyPut<PocketBaseService>(
      () => PocketBaseService(),
      fenix: true,
    ); // Register PocketBaseService in MainBinding
    Get.lazyPut<TimeService>(() {
      final timeService = TimeService();
      timeService.init(); // 初始化 TimeService
      return timeService;
    }, fenix: true); // Register TimeService in MainBinding
  }
}
