import 'package:bilibili_app/http/request/login_request.dart';

class RegisterRequest extends LoginRequest {
  @override
  String path() {
    return '/uapi/user/registration';
  }
}
