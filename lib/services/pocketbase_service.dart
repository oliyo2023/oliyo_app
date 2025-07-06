import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oliyo_app/constants/app_constants.dart';

class PocketBaseService extends GetxService {
  late final PocketBase pbClient;
  final Logger _logger = Logger('PocketBaseService');
  
  // 重试配置
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  Future<PocketBaseService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final store = AsyncAuthStore(
        save: (String data) async => prefs.setString(AppConstants.authTokenKey, data),
        initial: prefs.getString(AppConstants.authTokenKey),
      );

      pbClient = PocketBase(
        AppConstants.baseUrl,
        authStore: store,
      );
      
      _logger.info('PocketBase服务初始化成功');
      return this;
    } catch (e) {
      _logger.severe('PocketBase服务初始化失败: $e');
      rethrow;
    }
  }

  /// 带重试机制的API调用
  Future<T> callWithRetry<T>(Future<T> Function() apiCall) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        attempts++;
        _logger.warning('API调用失败 (尝试 $attempts/$maxRetries): $e');
        
        if (attempts >= maxRetries) {
          _logger.severe('API调用最终失败: $e');
          rethrow;
        }
        
        // 等待后重试
        await Future.delayed(retryDelay * attempts);
      }
    }
    throw Exception('未知错误');
  }

  /// 检查网络连接
  Future<bool> checkConnection() async {
    try {
      await callWithRetry(() => pbClient.health.check());
      return true;
    } catch (e) {
      _logger.warning('网络连接检查失败: $e');
      return false;
    }
  }

  /// 获取当前用户
  RecordModel? get currentUser => pbClient.authStore.model as RecordModel?;

  /// 检查是否已登录
  bool get isLoggedIn => pbClient.authStore.isValid;

  /// 获取认证token
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.authTokenKey);
    } catch (e) {
      _logger.warning('获取认证token失败: $e');
      return null;
    }
  }

  /// 登录
  Future<RecordAuth> login(String email, String password) async {
    return await callWithRetry(() => pbClient.collection('users').authWithPassword(email, password));
  }

  /// 注册
  Future<RecordModel> register(String email, String password, String passwordConfirm, Map<String, dynamic> body) async {
    // 暂时返回模拟数据，避免PocketBase API调用问题
    await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
    throw UnimplementedError('注册功能暂未实现');
  }

  /// 退出登录
  void logout() {
    pbClient.authStore.clear();
    _logger.info('用户已退出登录');
  }

  /// 刷新认证
  Future<RecordAuth> refreshAuth() async {
    return await callWithRetry(() => pbClient.collection('users').authRefresh());
  }
} 