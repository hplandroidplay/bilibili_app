import 'package:bilibili_app/http/core/net_manager.dart';
import 'package:bilibili_app/http/request/profile_request.dart';
import 'package:bilibili_app/model/profile_model.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await NetManager.getInstance().fire(request);
    print(result);
    return ProfileModel.fromJson(result['data']);
  }
}
