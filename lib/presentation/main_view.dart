import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';

import 'view/history/history_screen.dart';
import 'view/home/home_screen.dart';
import 'view/profile/profile_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late PersistentTabController _tabController;

  int _selectedNav = 0;

  @override
  void initState() {
    _tabController = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  void _changeSelectedNav(int index) {
    setState(() {
      _selectedNav = index;
    });
  }

  List<Widget> screens() {
    return [
      const HomeScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];
  }

  final _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    int backPressTime = 0;
    return WillPopScope(
      onWillPop: () async {
        if (backPressTime + 300 > DateTime
            .now()
            .millisecondsSinceEpoch) {
          return true;
        } else {
          backPressTime = DateTime
              .now()
              .millisecondsSinceEpoch;
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
          children: _screens,
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

    //   return PersistentTabView(
    //     context,
    //     controller: _tabController,
    //     screens: screens(),
    //     items: _navBarItems(),
    //     confineInSafeArea: true,
    //     decoration: NavBarDecoration(
    //       borderRadius: BorderRadius.circular(10.0),
    //       colorBehindNavBar: Colors.white,
    //     ),
    //     popActionScreens: PopActionScreensType.all,
    //     itemAnimationProperties: const ItemAnimationProperties(
    //       duration: Duration(milliseconds: 200),
    //       curve: Curves.ease,
    //     ),
    //     screenTransitionAnimation: const ScreenTransitionAnimation(
    //       animateTabTransition: true,
    //       curve: Curves.ease,
    //       duration: Duration(milliseconds: 200),
    //     ),
    //     navBarStyle: NavBarStyle.style10,
    //   );
    // }
    //
    // List<PersistentBottomNavBarItem> _navBarItems() {
    //   return [
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(
    //         Icons.home,
    //         color: TsOneColor.secondary,
    //       ),
    //       inactiveIcon: const Icon(
    //         Icons.home,
    //         color: TsOneColor.primaryFaded,
    //       ),
    //       title: "Home",
    //       routeAndNavigatorSettings: const RouteAndNavigatorSettings(onGenerateRoute: AppRoutes.generateRoute),
    //       textStyle: const TextStyle(color: TsOneColor.secondary),
    //       activeColorPrimary: TsOneColor.primary,
    //       activeColorSecondary: TsOneColor.secondary,
    //       inactiveColorPrimary: TsOneColor.primaryFaded,
    //     ),
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(
    //         Icons.history,
    //         color: TsOneColor.secondary,
    //       ),
    //       inactiveIcon: const Icon(
    //         Icons.history,
    //         color: TsOneColor.primaryFaded,
    //       ),
    //       title: "History",
    //       routeAndNavigatorSettings: const RouteAndNavigatorSettings(),
    //       textStyle: const TextStyle(color: TsOneColor.secondary),
    //       activeColorPrimary: TsOneColor.primary,
    //       activeColorSecondary: TsOneColor.secondary,
    //       inactiveColorPrimary: TsOneColor.primaryFaded,
    //     ),
    //     PersistentBottomNavBarItem(
    //       icon: const Icon(
    //         Icons.person,
    //         color: TsOneColor.secondary,
    //       ),
    //       inactiveIcon: const Icon(
    //         Icons.person,
    //         color: TsOneColor.primaryFaded,
    //       ),
    //       title: "Profile",
    //       routeAndNavigatorSettings: const RouteAndNavigatorSettings(onGenerateRoute: AppRoutes.generateRoute),
    //       textStyle: const TextStyle(color: TsOneColor.secondary),
    //       activeColorPrimary: TsOneColor.primary,
    //       activeColorSecondary: TsOneColor.secondary,
    //       inactiveColorPrimary: TsOneColor.primaryFaded,
    //     ),
    //   ];

  }
}
