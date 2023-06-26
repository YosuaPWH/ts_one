import 'package:flutter/material.dart';

import 'view/history/history_screen.dart';
import 'view/home/home_screen.dart';
import 'view/profile/profile_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedNav = 0;

  void _changeSelectedNav(int index) {
    setState(() {
      _selectedNav = index;
    });
  }

  final screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    int backPressTime = 0;
    return WillPopScope(
      onWillPop: () async {
        if (backPressTime + 300 > DateTime.now().millisecondsSinceEpoch) {
          return true;
        } else {
          backPressTime = DateTime.now().millisecondsSinceEpoch;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Ulangi lagi untuk keluar dari aplikasi",
            ),
          ));
          return false;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedNav,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedNav,
          selectedItemColor: Colors.red,
          showUnselectedLabels: true,
          onTap: _changeSelectedNav,
        ),
      ),
    );
  }
}
