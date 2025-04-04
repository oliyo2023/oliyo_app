import 'package:get/get.dart';
import 'package:oliyo_app/services/pocketbase_service.dart'; // 导入 PocketBaseService
import 'package:pocketbase/pocketbase.dart'; // 导入 PocketBase 相关类

class AuthController extends GetxController {
  final PocketBaseService pbService =
      Get.find<PocketBaseService>(); // 使用 PocketBaseService

  // 使用 Rx<RecordModel?> 来存储当前用户模型，使其可观察
  final Rx<RecordModel?> currentUser = Rx<RecordModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // 初始化时获取当前用户
    currentUser.value = pbService.pbClient.authStore.model as RecordModel?;

    // 监听认证状态变化
    pbService.pbClient.authStore.onChange.listen((AuthStoreEvent event) {
      currentUser.value = event.model as RecordModel?;
      // 你可以在这里添加其他逻辑，例如在用户登录/退出时导航
    });
  }

  // 提供一个 getter 判断用户是否登录
  bool get isLoggedIn => pbService.pbClient.authStore.isValid;

  // 可能需要添加登录、注册、退出等方法，这些方法会调用 pbService
  // 例如:
  // Future<void> login(String email, String password) async { ... }
  // Future<void> logout() async { ... }
}
