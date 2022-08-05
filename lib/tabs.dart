import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:toolhub/routes/browser.dart';
import 'package:toolhub/routes/home.dart';
import 'package:toolhub/routes/message.dart';
import 'package:toolhub/routes/settings.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final iconList = <IconData>[
    Icons.home_max_outlined,
    Icons.manage_accounts_outlined,
    Icons.call_merge_outlined,
    Icons.settings_rounded,
  ];

  var _bottomNavIndex = 0;
  PageController ctr = PageController(initialPage: 0);

  static final pages = [
    const HomePage(),
    const Browser(),
    const Message(),
    const SettingPage(),
  ];

  Widget buildBody() {
    return PageView.builder(
      controller: ctr,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return pages[index];
      },
    );
  }

  AnimatedBottomNavigationBar buildBar() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        Color color =
            _bottomNavIndex == index ? Colors.teal.shade500 : Colors.grey;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconList[index],
              size: 24,
              color: color,
            ),
          ],
        );
      },
      backgroundColor: Colors.white,
      activeIndex: _bottomNavIndex,
      splashColor: Colors.teal,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapWidth: 0,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
        ctr.jumpToPage(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: buildBar(),
    );
  }
}
