import 'package:get/get.dart';
import 'package:oliyo_app/pages/clock/clock_page.dart';
import 'package:oliyo_app/pages/main/main_page.dart';
import 'package:oliyo_app/pages/auth/login_page.dart';
import 'package:oliyo_app/pages/auth/register_page.dart';
import 'package:oliyo_app/pages/splash/splash_page.dart';
import 'package:oliyo_app/bindings/auth_binding.dart';
import 'package:oliyo_app/bindings/main_binding.dart';
import 'package:oliyo_app/bindings/clock_binding.dart';
import 'package:oliyo_app/pages/home/quit_smoking_home_page.dart';
import 'package:oliyo_app/pages/smoking_plan/smoking_plan_page.dart';
import 'package:oliyo_app/pages/savings_calculator/savings_calculator_page.dart';
import 'package:oliyo_app/pages/health_data/health_data_page.dart';
import 'package:oliyo_app/pages/community/community_page.dart';
import 'package:oliyo_app/pages/message/message_page.dart';
import 'package:oliyo_app/pages/learning/learning_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    // 戒烟助手相关路由
    GetPage(
      name: Routes.quitSmokingHome,
      page: () => const QuitSmokingHomePage(),
    ),
    GetPage(name: Routes.smokingPlan, page: () => const SmokingPlanPage()),
    GetPage(
      name: Routes.savingsCalculator,
      page: () => const SavingsCalculatorPage(),
    ),
    GetPage(name: Routes.healthData, page: () => const HealthDataPage()),
    GetPage(name: Routes.community, page: () => const CommunityPage()),
    GetPage(
      name: Routes.clock,
      page: () => const ClockPage(),
      binding: ClockBinding(),
    ),
    GetPage(name: Routes.message, page: () => const MessagePage()),
    GetPage(name: Routes.learning, page: () => const LearningPage()),
  ];
}
