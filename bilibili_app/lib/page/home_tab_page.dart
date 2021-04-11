import 'package:bilibili_app/core/base_tab_state.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_model.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/widget/custom_banner.dart';
import 'package:bilibili_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// 首页 tab 下的页面，就是一个 列表，实现下拉刷新和加载更多
class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel> bannerList;

  const HomeTabPage({Key key, this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends BaseTabState<HomeModel, VideoModel, HomeTabPage> {
  @override
  get contentChild => StaggeredGridView.countBuilder(
      // 别表
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      crossAxisCount: 2,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        //有banner时第一个item位置显示banner
        if (widget.bannerList != null && index == 0) {
          return Padding(padding: EdgeInsets.only(bottom: 8), child: _banner());
        } else {
          return VideoCard(videoMo: dataList[index]);
        }
      },
      staggeredTileBuilder: (int index) {
        //每一个item 占据几列
        if (widget.bannerList != null && index == 0) {
          return StaggeredTile.fit(2);
        } else {
          return StaggeredTile.fit(1);
        }
      });

  @override
  Future<HomeModel> getData(int pageIndex) async {
    return await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    return result.videoList;
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: CustomBanner(widget.bannerList));
  }
}
