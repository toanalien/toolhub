import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

  AnimatedBottomNavigationBar buildBar() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? Colors.blueAccent : Colors.grey;
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
      splashColor: Colors.blueAccent,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapWidth: 0,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      onTap: (index) => setState(() => _bottomNavIndex = index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toolhub', style: Theme.of(context).textTheme.headline6),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Text('$_bottomNavIndex'),
      bottomNavigationBar: buildBar(),
    );
  }
}
