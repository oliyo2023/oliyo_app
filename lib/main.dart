import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliyo_app/pages/home/home_page.dart';
import 'package:oliyo_app/routes/app_pages.dart';
// 导入 AppController
// 导入 PocketBaseService
// 导入 TimeService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Oliyo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      getPages: AppPages.routes,
    );
  }
}
