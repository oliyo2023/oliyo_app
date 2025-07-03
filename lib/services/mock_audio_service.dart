import 'package:get/get.dart';
import 'package:logging/logging.dart';

/// 模拟音频播放服务
/// 在实际项目中，这里会使用真实的音频文件
class MockAudioService extends GetxService {
  static final _logger = Logger('MockAudioService');
  
  final RxBool _isPlaying = false.obs;
  final RxString _currentItemId = ''.obs;

  bool get isPlaying => _isPlaying.value;
  String get currentItemId => _currentItemId.value;

  /// 模拟播放音频
  Future<void> playAudio(String itemId, String itemName) async {
    try {
      _logger.info('模拟播放音频: $itemName (ID: $itemId)');
      
      // 停止当前播放
      if (_isPlaying.value) {
        await stopAudio();
      }
      
      // 开始播放
      _currentItemId.value = itemId;
      _isPlaying.value = true;
      
      // 显示播放提示
      Get.snackbar(
        '正在播放',
        '🔊 $itemName',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // 模拟播放时长（2秒）
      await Future.delayed(const Duration(seconds: 2));
      
      // 播放完成
      _isPlaying.value = false;
      _currentItemId.value = '';
      
    } catch (e) {
      _logger.severe('播放音频时出错: $e');
      _isPlaying.value = false;
      _currentItemId.value = '';
      
      Get.snackbar(
        '播放错误',
        '无法播放音频',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 停止播放音频
  Future<void> stopAudio() async {
    _logger.info('停止播放音频');
    _isPlaying.value = false;
    _currentItemId.value = '';
  }

  /// 检查指定项目是否正在播放
  bool isItemPlaying(String itemId) {
    return _isPlaying.value && _currentItemId.value == itemId;
  }
}
