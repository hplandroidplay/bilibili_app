import 'package:bilibili_app/page/unkonown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

///Widget测试
void main() {
  testWidgets('测试UnKnownPage', (WidgetTester widgetTester) async {
    var app = MaterialApp(home: UnKnownPage());
    await widgetTester.pumpWidget(app);
    //断言，找到页面上的一个元素，对比，和UI test 一样
    expect((find.text('404')), findsOneWidget);
  });
}
