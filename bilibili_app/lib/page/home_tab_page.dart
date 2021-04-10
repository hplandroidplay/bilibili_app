import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_model.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/utils/color.dart';
import 'package:bilibili_app/utils/toast.dart';
import 'package:bilibili_app/widget/banner.dart';
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

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:$dis');
      //当距离底部不足300时加载更多
      if (dis < 300 && !_loading) {
        print('------_loadData---');
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      //下拉刷新
      onRefresh: _loadData,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              // 别表
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              crossAxisCount: 2,
              itemCount: videoList.length,
              itemBuilder: (BuildContext context, int index) {
                //有banner时第一个item位置显示banner
                if (widget.bannerList != null && index == 0) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 8), child: _banner());
                } else {
                  return VideoCard(videoMo: videoList[index]);
                }
              },
              staggeredTileBuilder: (int index) {
                //每一个item 占据几列
                if (widget.bannerList != null && index == 0) {
                  return StaggeredTile.fit(2);
                } else {
                  return StaggeredTile.fit(1);
                }
              })),
    );
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: MyBanner(widget.bannerList));
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');
    try {
      HomeModel result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            //合成一个新数组
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
