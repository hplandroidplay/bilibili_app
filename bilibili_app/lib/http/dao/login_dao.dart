import 'package:bilibili_app/da/cache_manager.dart';
import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:bilibili_app/http/request/login_request.dart';
import 'package:bilibili_app/http/request/register_request.dart';
import 'package:bilibili_app/utils/string_util.dart';

/// 登录和注册的dao，在dao 里面主要提供的书静态的方法
class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

  static login(String userName, String password, String courseFlag) {
    return _send(userName, password, courseFlag: courseFlag);
  }

  static register(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password,
      {String courseFlag, String imoocId, String orderId}) async {
    BaseRequest request;
    if (isNotEmpty(imoocId)) {
      request = RegisterRequest();
    } else {
      request = LoginRequest();
    }
    request
        .add("userName", userName)
        .add("password", password)
        .add("courseFlag", courseFlag)
        .add("imoocId", imoocId)
        .add("orderId", orderId);

    var result = await NetManager.getInstance().fire(request);

    if (result["code"] == 0 && result["data"] != null) {
      // 保存token到本地
      CacheManager.getInstance().setString(BOARDING_PASS, result["data"]);
    }
    return result;
  }
}
