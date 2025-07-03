import 'package:get/get.dart';
import 'package:oliyo_app/controllers/auth_controller.dart';
import 'package:oliyo_app/services/pocketbase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    Get.put(prefs, permanent: true);

    // Initialize PocketBaseService asynchronously and make it permanent
    await Get.putAsync(() => PocketBaseService().init(), permanent: true);

    // Initialize AuthController after PocketBaseService is ready
    Get.put(AuthController(), permanent: true);
  }
}