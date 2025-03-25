import 'package:get/get.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:oliyo_app/controllers/login_controller.dart';
import 'package:oliyo_app/controllers/register_controller.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PocketBaseService>(() => PocketBaseService(), fenix: true); // 注册 PocketBaseService
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true); // 注册 AuthController
    Get.lazyPut(() => LoginController(), fenix: true); // 注册 LoginController
    Get.lazyPut(() => RegisterController(), fenix: true); // 注册 RegisterController
  }
} 