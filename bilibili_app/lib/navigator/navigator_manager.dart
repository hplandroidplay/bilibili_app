import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/page/registration_page.dart';
import 'package:flutter/material.dart';

import 'bottom_navigator.dart';

/// 导航管理  主要完成
/// 页面跳转监听
typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo pre);

///创建MaterialPage页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

///自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown }

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } /*else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  }*/
  else {
    return RouteStatus.unknown;
  }
}

///路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// 路由管理，两个目标：1. 实现路由跳转 2. 页面进栈和出栈的监听
class NavigatorManager extends _RouteJumpListener {
  static NavigatorManager _instance;

  RouteJumpListener _routeJump;
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo _current;

  //首页底部tab
  RouteStatusInfo _bottomTab;

  NavigatorManager._();

  static NavigatorManager getInstance() {
    if (_instance == null) {
      _instance = NavigatorManager._();
    }
    return _instance;
  }

  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab);
  }

  ///注册路由跳转逻辑，在 RouterDelegate 进行调用
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  ///监听路由页面跳转，在具体页面进行监听，如首页等
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  /// 页面跳转，如何实现的由  RouterDelegate 来实现
  @override
  void onJumpTo(RouteStatus routeStatus, {Map args}) {
    _routeJump.onJumpTo(routeStatus, args: args);
  }

  ///通知路由页面变化，在 RouterDelegate 进行调用
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      //如果打开的是首页，则明确到首页具体的tab
      current = _bottomTab;
    }
    print('hi_navigator:current:${current.page}');
    print('hi_navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}

///抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({this.onJumpTo});
}
