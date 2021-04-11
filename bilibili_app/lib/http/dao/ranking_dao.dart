import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/ranking_request.dart';
import 'package:bilibili_app/model/ranking_model.dart';

///排行榜
class RankingDao {
  //https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=40
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return RankingModel.fromJson(result["data"]);
  }
}
