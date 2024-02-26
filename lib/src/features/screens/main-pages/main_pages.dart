import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/screens/pages/calendar.dart';
import 'package:thanhson/src/features/screens/pages/process.dart';
import 'package:thanhson/src/features/screens/pages/setting.dart';

class MainPages extends StatefulWidget {
  final int index;

  const MainPages({super.key, required this.index});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Working Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Today Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        activeColor: mainColor,
        inactiveColor: Colors.black,
        border: const Border(
          top: BorderSide(color: Colors.black),
        ),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const SafeArea(
                  child: CupertinoPageScaffold(child: Calendar()),
                );
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const SafeArea(
                  child: CupertinoPageScaffold(child: Process()),
                );
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return const SafeArea(
                  child: CupertinoPageScaffold(child: Setting()),
                );
              },
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
