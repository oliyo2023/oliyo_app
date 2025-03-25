import 'package:flutter/material.dart';
import 'package:oliyo_app/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const int messagesIndex = 1;
  static const int clockIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('首页内容')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: '时钟'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == messagesIndex) {
            Navigator.pushNamed(context, Routes.messages);
          } else if (index == clockIndex) {
            Navigator.pushNamed(context, Routes.clock);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
