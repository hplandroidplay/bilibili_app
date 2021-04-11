import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:bilibili_app/http/request/cancel_favorite_request.dart';
import 'package:bilibili_app/http/request/favorite_request.dart';

class FavoriteDao {
  // https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return result;
  }
}
