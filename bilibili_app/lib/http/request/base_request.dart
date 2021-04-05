/// request 的基类
enum HttpMethod { GET, POST, DELETE }

abstract class BaseRequest {
  var pathParams;
  var useHttps = true;
  Map<String, String> params = Map();

  Map<String, dynamic> header = {
    'course-flag': 'fa',
    "auth-token": "MjAyMC0wNi0yMyAwMzoyNTowMQ==fa",
  };

  ///添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  ///添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }

  String url() {
    Uri uri;
    var pathStr = path();
    //拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      // addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  /// 请求的域名
  String authority() => "api.devio.org";

  /// url 的相对路径
  String path();

  /// 是否需要登录
  bool needLogin();

  ///http 请求的方法
  HttpMethod httpMethod();
}
