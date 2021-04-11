import 'package:bilibili_app/core/base_tab_state.dart';
import 'package:bilibili_app/http/dao/favorite_dao.dart';
import 'package:bilibili_app/model/ranking_model.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/navigator_manager.dart';
import 'package:bilibili_app/utils/view_util.dart';
import 'package:bilibili_app/widget/navigation_bar.dart';
import 'package:bilibili_app/widget/video_large_card.dart';
import 'package:flutter/cupertino.dart';

import 'video_details_page.dart';

///收藏

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState
    extends BaseTabState<RankingModel, VideoModel, FavoritePage> {
  RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    NavigatorManager.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    NavigatorManager.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    );
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: Text('收藏', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            VideoLargeCard(videoModel: dataList[index]),
      );

  @override
  Future<RankingModel> getData(int pageIndex) async {
    RankingModel result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }
}
