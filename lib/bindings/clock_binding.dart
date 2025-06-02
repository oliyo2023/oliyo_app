import 'package:get/get.dart';
import 'package:oliyo_app/services/time_service.dart';

class ClockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeService>(() {
      final timeService = TimeService();
      timeService.init(); // 初始化 TimeService
      return timeService;
    }, fenix: true); // Register TimeService for ClockPage
  }
}
