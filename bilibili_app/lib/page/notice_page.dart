import 'package:bilibili_app/core/base_tab_state.dart';
import 'package:bilibili_app/http/dao/notice_dao.dart';
import 'package:bilibili_app/model/home_model.dart';
import 'package:bilibili_app/model/notice_model.dart';
import 'package:bilibili_app/widget/notice_card.dart';
import 'package:flutter/material.dart';

///通知列表页
class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState
    extends BaseTabState<NoticeModel, BannerModel, NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    ));
  }

  _buildNavigationBar() {
    return AppBar(
      title: Text('通知'),
    );
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            NoticeCard(bannerMo: dataList[index]),
      );

  @override
  Future<NoticeModel> getData(int pageIndex) async {
    NoticeModel result =
        await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<BannerModel> parseList(NoticeModel result) {
    return result.list;
  }
}
