import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:oliyo_app/models/learning_item.dart';
import 'package:oliyo_app/services/mock_audio_service.dart';
import 'package:logging/logging.dart';

class LearningController extends GetxController {
  static final _logger = Logger('LearningController');

  final AudioPlayer _audioPlayer = AudioPlayer();
  final MockAudioService _mockAudioService = Get.put(MockAudioService());
  final RxList<LearningItem> _allItems = <LearningItem>[].obs;
  final RxList<LearningItem> _filteredItems = <LearningItem>[].obs;
  final Rx<LearningCategory?> _selectedCategory = Rx<LearningCategory?>(null);
  final RxBool _isLoading = false.obs;

  // Getters
  List<LearningItem> get allItems => _allItems;
  List<LearningItem> get filteredItems => _filteredItems;
  LearningCategory? get selectedCategory => _selectedCategory.value;
  bool get isLoading => _isLoading.value;
  bool get isPlaying => _mockAudioService.isPlaying;
  String get currentPlayingId => _mockAudioService.currentItemId;
  List<LearningCategory> get categories => LearningCategory.values;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _setupAudioPlayerListeners();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  /// 初始化学习数据
  void _initializeData() {
    _isLoading.value = true;

    // 模拟数据 - 实际项目中可以从API或本地数据库加载
    _allItems.value = [
      // 动物类
      const LearningItem(
        id: 'animal_cat',
        name: '小猫',
        imagePath: 'assets/images/learning/animals/cat.png',
        audioPath: 'assets/audio/learning/animals/cat.mp3',
        category: LearningCategory.animals,
        description: '可爱的小猫咪',
      ),
      const LearningItem(
        id: 'animal_dog',
        name: '小狗',
        imagePath: 'assets/images/learning/animals/dog.png',
        audioPath: 'assets/audio/learning/animals/dog.mp3',
        category: LearningCategory.animals,
        description: '忠诚的小狗狗',
      ),
      const LearningItem(
        id: 'animal_rabbit',
        name: '兔子',
        imagePath: 'assets/images/learning/animals/rabbit.png',
        audioPath: 'assets/audio/learning/animals/rabbit.mp3',
        category: LearningCategory.animals,
        description: '蹦蹦跳跳的兔子',
      ),

      // 水果类
      const LearningItem(
        id: 'fruit_apple',
        name: '苹果',
        imagePath: 'assets/images/learning/fruits/apple.png',
        audioPath: 'assets/audio/learning/fruits/apple.mp3',
        category: LearningCategory.fruits,
        description: '红红的苹果',
      ),
      const LearningItem(
        id: 'fruit_banana',
        name: '香蕉',
        imagePath: 'assets/images/learning/fruits/banana.png',
        audioPath: 'assets/audio/learning/fruits/banana.mp3',
        category: LearningCategory.fruits,
        description: '黄黄的香蕉',
      ),
      const LearningItem(
        id: 'fruit_orange',
        name: '橙子',
        imagePath: 'assets/images/learning/fruits/orange.png',
        audioPath: 'assets/audio/learning/fruits/orange.mp3',
        category: LearningCategory.fruits,
        description: '酸甜的橙子',
      ),

      // 交通工具类
      const LearningItem(
        id: 'vehicle_car',
        name: '汽车',
        imagePath: 'assets/images/learning/vehicles/car.png',
        audioPath: 'assets/audio/learning/vehicles/car.mp3',
        category: LearningCategory.vehicles,
        description: '快速的汽车',
      ),
      const LearningItem(
        id: 'vehicle_bus',
        name: '公交车',
        imagePath: 'assets/images/learning/vehicles/bus.png',
        audioPath: 'assets/audio/learning/vehicles/bus.mp3',
        category: LearningCategory.vehicles,
        description: '大大的公交车',
      ),
    ];

    _filteredItems.value = _allItems;
    _isLoading.value = false;
  }

  /// 设置音频播放器监听器
  void _setupAudioPlayerListeners() {
    // 使用模拟音频服务，不需要真实的音频播放器监听器
    _logger.info('Audio player listeners setup completed (using mock service)');
  }

  /// 播放音频
  Future<void> playAudio(LearningItem item) async {
    try {
      _logger.info('Playing audio for item: ${item.name}');

      // 使用模拟音频服务播放
      await _mockAudioService.playAudio(item.id, item.name);
    } catch (e) {
      _logger.severe('Error playing audio: $e');
      Get.snackbar('播放错误', '无法播放音频文件');
    }
  }

  /// 停止音频播放
  Future<void> stopAudio() async {
    try {
      await _mockAudioService.stopAudio();
    } catch (e) {
      _logger.warning('Error stopping audio: $e');
    }
  }

  /// 根据分类筛选项目
  void filterByCategory(LearningCategory? category) {
    _selectedCategory.value = category;

    if (category == null) {
      _filteredItems.value = _allItems;
    } else {
      _filteredItems.value =
          _allItems.where((item) => item.category == category).toList();
    }
  }

  /// 获取分类中的项目数量
  int getCategoryItemCount(LearningCategory category) {
    return _allItems.where((item) => item.category == category).length;
  }

  /// 检查项目是否正在播放
  bool isItemPlaying(String itemId) {
    return _mockAudioService.isItemPlaying(itemId);
  }
}
