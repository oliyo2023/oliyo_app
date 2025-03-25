import 'package:get/get.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs; // 默认选中首页
  
  void changePage(int index) {
    currentIndex.value = index;
  }
} 