import 'package:get/get.dart';
import 'package:oliyo_app/pages/main/main_page.dart';
import 'package:oliyo_app/pages/auth/login_page.dart';
import 'package:oliyo_app/pages/auth/register_page.dart';
import 'package:oliyo_app/bindings/auth_binding.dart';
import 'package:oliyo_app/bindings/main_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.main;

  static final routes = [
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
  ];
} 