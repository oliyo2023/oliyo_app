import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketBaseService extends GetxService {
  late final PocketBase pbClient;

  Future<PocketBaseService> init() async {
    final prefs = Get.find<SharedPreferences>();

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    pbClient = PocketBase('https://8.140.206.248/pocketbase', authStore: store);
    // 可以在这里添加任何初始化逻辑
    return this;
  }
} 