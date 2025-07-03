import 'package:get/get.dart';
import 'package:oliyo_app/controllers/discover_controller.dart';
import 'package:oliyo_app/controllers/home_controller.dart';
import 'package:oliyo_app/controllers/main_controller.dart';
import 'package:oliyo_app/controllers/news_controller.dart';
import 'package:oliyo_app/controllers/profile_controller.dart';
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

    // 注意：AuthController 和 PocketBaseService 在 InitialBinding 中初始化
    // 这里只是确保在需要时可以安全访问

    Get.lazyPut<TimeService>(() {
      final timeService = TimeService();
      timeService.init(); // 初始化 TimeService
      return timeService;
    }, fenix: true); // Register TimeService in MainBinding
  }
}
