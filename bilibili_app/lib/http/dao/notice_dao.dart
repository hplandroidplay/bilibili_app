import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/notice_request.dart';
import 'package:bilibili_app/model/notice_model.dart';

///通知列表Dao
class NoticeDao {
  //https://api.devio.org/uapi/fa/notice?pageIndex=1&pageSize=10
  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return NoticeModel.fromJson(result['data']);
  }
}
