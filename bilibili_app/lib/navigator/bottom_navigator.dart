import 'package:bilibili_app/navigator/navigator_manager.dart';
import 'package:bilibili_app/page/favorite_page.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/profile_page.dart';
import 'package:bilibili_app/page/ranking_page.dart';
import 'package:bilibili_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 这是APP 首页的底部导航栏，由 pageView 和 BottomNavigationBar 构成
class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;

  /// pageView 控制器
  final PageController _controller = PageController(initialPage: initialPage);
  List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [HomePage(), RankingPage(), FavoritePage(), ProfilePage()];
    if (!_hasBuild) {
      // 第一次进来通知 NavigatorManager 底部 tab 发生变化
      _hasBuild = true;
      NavigatorManager.getInstance().onBottomTabChange(0, _pages[0]);
    }
    return Scaffold(
      body: PageView(
        children: _pages,
        controller: _controller,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _onJumpTo(index),
        selectedItemColor: _activeColor,
        items: [
          _getBottomItem('首页', Icons.home, 0),
          _getBottomItem('排行榜', Icons.local_fire_department, 1),
          _getBottomItem('收藏', Icons.favorite, 2),
          _getBottomItem('我的', Icons.emoji_people_rounded, 3),
        ],
      ),
    );
  }

  _getBottomItem(String tab, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: tab);
  }

  _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      // 这里是真正的切换页面
      _controller.jumpToPage(index);
    } else {
      // 通知 NavigatorManager 底部的tab 发生变化了
      NavigatorManager.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
