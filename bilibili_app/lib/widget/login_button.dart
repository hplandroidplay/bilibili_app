import 'package:bilibili_app/utils/color.dart';
import 'package:flutter/material.dart';

/// 登陆的按钮
class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onPressed; //回调函数到时封装好的，前面代表返回值的类型

  const LoginButton(this.title, {Key key, this.enable = true, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        onPressed: enable ? onPressed : null,
        disabledColor: primary[50],
        color: primary,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
