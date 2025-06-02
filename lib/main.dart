import 'package:flutter/material.dart';
import 'package:oliyo_app/pages/home/home_page.dart';
// 导入路由定义
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
    return MaterialApp(
      title: 'Oliyo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
