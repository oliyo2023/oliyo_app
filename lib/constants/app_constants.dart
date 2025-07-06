/// 应用常量配置
class AppConstants {
  // 应用信息
  static const String appName = 'Oliyo App';
  static const String appVersion = '1.0.0';
  
  // API配置
  static const String baseUrl = 'https://8.140.206.248/pocketbase';
  static const int connectionTimeout = 30000; // 30秒
  static const int receiveTimeout = 30000; // 30秒
  
  // 本地存储键
  static const String authTokenKey = 'pb_auth';
  static const String userPreferencesKey = 'user_preferences';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // 尺寸常量
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  
  // 颜色常量
  static const int primaryColorValue = 0xFF4A90E2;
  static const int secondaryColorValue = 0xFF607D8B;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFE91E63;
  
  // 学习相关常量
  static const int maxLearningItemsPerPage = 20;
  static const Duration audioPlaybackTimeout = Duration(seconds: 30);
  
  // 戒烟相关常量
  static const int defaultSmokingGoal = 0; // 每天0支烟
  static const double defaultCigarettePrice = 20.0; // 每包烟价格
  static const int cigarettesPerPack = 20; // 每包烟支数
}

/// 路由常量
class RouteConstants {
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String clock = '/clock';
  static const String quitSmokingHome = '/quit-smoking-home';
  static const String smokingPlan = '/smoking-plan';
  static const String savingsCalculator = '/savings-calculator';
  static const String healthData = '/health-data';
  static const String community = '/community';
  static const String message = '/message';
  static const String learning = '/learning';
}

/// 错误消息常量
class ErrorMessages {
  static const String networkError = '网络连接错误，请检查网络设置';
  static const String serverError = '服务器错误，请稍后重试';
  static const String authenticationError = '认证失败，请重新登录';
  static const String validationError = '输入数据验证失败';
  static const String unknownError = '未知错误，请稍后重试';
}

/// 成功消息常量
class SuccessMessages {
  static const String loginSuccess = '登录成功';
  static const String registerSuccess = '注册成功';
  static const String logoutSuccess = '退出登录成功';
  static const String saveSuccess = '保存成功';
  static const String deleteSuccess = '删除成功';
} 