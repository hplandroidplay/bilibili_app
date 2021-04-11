import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:bilibili_app/http/request/cancel_like_request.dart';
import 'package:bilibili_app/http/request/like_request.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1A5411L71X
  static like(String vid, bool like) async {
    BaseRequest request = like ? LikeRequest() : CancelLikeRequest();
    request.pathParams = vid;
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return result;
  }
}
