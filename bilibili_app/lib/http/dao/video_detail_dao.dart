import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/video_detail_request.dart';
import 'package:bilibili_app/model/video_detail_model.dart';

///详情页Dao
class VideoDetailDao {
  //https://api.devio.org/uapi/fa/detail/BV19C4y1s7Ka
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return VideoDetailModel.fromJson(result['data']);
  }
}
