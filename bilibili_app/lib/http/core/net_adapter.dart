import 'package:bilibili_app/http/request/base_request.dart';

import 'net_response.dart';

/// 网络请求的适配器
abstract class NetAdapter {
  Future<NetResponse<T>> send<T>(BaseRequest request);
}
