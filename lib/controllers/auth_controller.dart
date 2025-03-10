import 'package:get/get.dart';
import 'package:oliyo_app/services/pocketbase_service.dart'; // 导入 PocketBaseService

class AuthController extends GetxController {
  final PocketBaseService pbService = Get.find<PocketBaseService>(); // 使用 PocketBaseService

} 