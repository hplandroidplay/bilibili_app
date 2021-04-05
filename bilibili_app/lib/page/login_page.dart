import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/page/registration_page.dart';
import 'package:bilibili_app/utils/string_util.dart';
import 'package:bilibili_app/utils/toast.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_button.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 登录的页面：
///登录页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegistrationPage()));
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: LoginButton(
                  '登录',
                  enable: loginEnable,
                  onPressed: send,
                ))
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName, password, "fa");
      print(result);
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
