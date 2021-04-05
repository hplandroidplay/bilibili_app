import 'package:bilibili_app/http/core/net_adapter.dart';
import 'package:bilibili_app/http/core/net_response.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:dio/dio.dart';

import '../net_error.dart';

class DioNetAdapter extends NetAdapter {
  @override
  Future<NetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header); //添加请求头
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      ///抛出HiNetError
      throw NetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

  ///构建HiNetResponse
  NetResponse buildRes(Response response, BaseRequest request) {
    return NetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
