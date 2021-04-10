import 'package:bilibili_app/da/cache_manager.dart';
import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/bottom_navigator.dart';
import 'package:bilibili_app/navigator/navigator_manager.dart';
import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/page/registration_page.dart';
import 'package:bilibili_app/utils/toast.dart';
import 'package:flutter/material.dart';

import 'page/video_details_page.dart';
import 'utils/color.dart';

/// APP 的主页面
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CacheManager>(
        future: CacheManager.preInit(),
        builder: (BuildContext context, AsyncSnapshot<CacheManager> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );

          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

// 路由代理，ChangeNotifier 可以通过notify 修改路由的状态，引入 PopNavigatorRouterDelegateMixin 是为了使用它的popRouteff；
//BiliRoutePath：决定显示哪些页面所需的所有状态
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    NavigatorManager.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map args}) {
      _routeStatus = routeStatus; //只是改变 _routeStatus 的值
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args['videoMo'];
      }
      notifyListeners(); //通知 Router 重建 RouterDelegate（通过 build() 方法）
    }));
    //设置网络错误拦截器
    NetManager.getInstance().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        CacheManager.getInstance().setString(LoginDao.BOARDING_PASS, null);
        //拉起登录
        NavigatorManager.getInstance().onJumpTo(RouteStatus.login);
      }
    });
  }

  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = []; //存放所有的页面信息
  VideoModel videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus); // 获取页面在路由列表的第几个位置
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    //通知路由发生变化通知到每个页面，第一个参数的 当前的路由列表、第二个参数的之前的路由列表，
    NavigatorManager.getInstance().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
      //路由出站的处理
      //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
      onWillPop: () async => !await navigatorKey.currentState.maybePop(),
      child: Navigator(
        // 返回一个新的 Navigator
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          // 页面退出的处理
          if (route.settings is MaterialPage) {
            // 这是什么？
            //登录页未登录返回拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("请先登录");
                return false;
              }
            }
          }
          //执行返回操作
          if (!route.didPop(result)) {
            return false;
          }
          var tempPages = [...pages];
          pages.removeLast(); //移除最后一个元素
          //通知路由发生变化
          NavigatorManager.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  /// 当一个新的路由被push时，Router会调用setNewRoutePath，这样我们的应用就有机会根据路由的变化来更新应用状态
  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

///1.定义路由数据，path
class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
