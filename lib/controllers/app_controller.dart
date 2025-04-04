import 'package:get/get.dart';

class AppController extends GetxController {
  // 使用 RxString 使标题可观察
  final RxString appTitle = 'Oliyo Application'.obs;

  // 提供一个方法来更新标题（可选，但方便）
  void updateAppTitle(String newTitle) {
    appTitle.value = newTitle;
  }
}
