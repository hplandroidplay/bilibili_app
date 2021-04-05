import 'package:bilibili_app/http/core/adapter/dio_net_adapter.dart';
import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/core/net_response.dart';
import 'package:bilibili_app/http/request/base_request.dart';

/// 网络请求的管理类
///
class NetManager {
  static NetManager _manager;

  static NetManager getInstance() {
    if (_manager == null) {
      _manager = NetManager._();
    }
    return _manager;
  }

  ///私有构造方法
  NetManager._();

  /// 发送网络请求的ff
  Future fire(BaseRequest request) async {
    NetResponse response;
    var error;
    try {
      response = await _send(request);
    } on NetError catch (e) {
      // 自定义的异常
      error = e;
      response = e.data;
      printLog(e);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }

    /// 获取数据
    var result = response.data;
    var statusCode = response.statusCode;
    printLog("statusCode:$statusCode::result$result");
    switch (statusCode) {
      case 200:
        return result;
        break;
      case 401:
        throw NeedLogin();
        break;
      case 403:
        throw NeedAuth(result.toString(), data: result);
        break;
      default:
        throw NetError(statusCode, result.toString(), data: result);
        break;
    }
  }

  Future<NetResponse<T>> _send<T>(BaseRequest request) async {
    DioNetAdapter adapter = DioNetAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print("net log:$log");
  }
}
