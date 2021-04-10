import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/home_request.dart';
import 'package:bilibili_app/model/home_model.dart';

class HomeDao {
  //https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return HomeModel.fromJson(result['data']);
  }
}
