import 'package:bilibili_app/da/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ///测试HiCache的存储和读取
  test('测试HiCache', () async {
    //fix ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
    TestWidgetsFlutterBinding.ensureInitialized();
    //fix MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/shared_preferences)
    SharedPreferences.setMockInitialValues({});
    await CacheManager.preInit();
    var key = "testHiCache", value = "Hello.";
    //设置值
    CacheManager.getInstance().setString(key, value);
    // 断言
    expect(CacheManager.getInstance().get(key), value);
  });
}
