import 'package:shared_preferences/shared_preferences.dart';

/// 这是数据的存储类，可以通过 sp 获取或是从数据库里面获取

class CacheManager {
  CacheManager._() {
    init();
  }

  static CacheManager _manager;
  SharedPreferences sharedPreferences;

  static CacheManager getInstance() {
    if (_manager == null) _manager = CacheManager._();
    return _manager;
  }

  /// 要在APP 的入口初始化，否则在使用的时候，可能会出现没有初始化完成，导致获取的sharedPreferences 为null
  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  CacheManager._pre(SharedPreferences prefs) {
    this.sharedPreferences = prefs;
  }

  ///预初始化，防止在使用get时，prefs还未完成初始化
  static Future<CacheManager> preInit() async {
    if (_manager == null) {
      var prefs = await SharedPreferences.getInstance();
      _manager = CacheManager._pre(prefs);
    }
    return _manager;
  }

  /// 数据测存储
  setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  setDouble(String key, double value) {
    sharedPreferences.setDouble(key, value);
  }

  setInt(String key, int value) {
    sharedPreferences.setInt(key, value);
  }

  setBool(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    sharedPreferences.setStringList(key, value);
  }

  T get<T>(String key) {
    return sharedPreferences.get(key);
  }
}
