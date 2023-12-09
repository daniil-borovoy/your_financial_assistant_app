import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:your_financial_assistant_app/src/pages/assistant.dart';
import 'package:your_financial_assistant_app/src/pages/pages.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(changePageIndex: _changePageIndex),
      const TransactionsScreen(),
      const AssistantScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monetization_on),
            label: 'Transactions'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: 'Assistent'.tr,
          ),
        ],
      ),
    );
  }

  _changePageIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
