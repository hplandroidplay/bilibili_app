import 'dart:io';

import 'package:bilibili_app/barrage/hi_barrage.dart';
import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/favorite_dao.dart';
import 'package:bilibili_app/http/dao/like_dao.dart';
import 'package:bilibili_app/http/dao/video_detail_dao.dart';
import 'package:bilibili_app/model/video_detail_model.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/utils/toast.dart';
import 'package:bilibili_app/utils/view_util.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/custom_tab.dart';
import 'package:bilibili_app/widget/expandable_content.dart';
import 'package:bilibili_app/widget/navigation_bar.dart';
import 'package:bilibili_app/widget/video/video_view.dart';
import 'package:bilibili_app/widget/video_header.dart';
import 'package:bilibili_app/widget/video_large_card.dart';
import 'package:bilibili_app/widget/video_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailModel videoDetailMo;
  VideoModel videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();

  @override
  void initState() {
    super.initState();
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(
            children: [
              //iOS 黑色状态栏
              NavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _buildVideoView(),
              _buildTabNavigation(),
              Flexible(
                  child: TabBarView(
                controller: _controller,
                children: [
                  _buildDetailList(),
                  Container(
                    child: Text('敬请期待...'),
                  )
                ],
              )),
            ],
          )),
    );
  }

  _buildVideoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(key: _barrageKey, vid: model.vid, autoPlay: true),
    );
  }

  _buildTabNavigation() {
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return CustomTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  /// 简介页面
  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  /// 简介头部列表
  buildContents() {
    return [
      if (videoModel.owner != null)
        VideoHeader(
          owner: videoModel.owner,
        ),
      ExpandableContent(model: videoModel),
      VideoToolBar(
        detailModel: videoDetailMo,
        videoModel: videoModel,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailModel result = await VideoDetailDao.get(videoModel.vid);
      print(result);
      setState(() {
        videoDetailMo = result;
        //更新旧的数据
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      print(e);
    }
  }

  ///点赞
  _doLike() async {
    try {
      var result = await LikeDao.like(videoModel.vid, !videoDetailMo.isLike);
      print(result);
      videoDetailMo.isLike = !videoDetailMo.isLike;
      if (videoDetailMo.isLike) {
        videoModel.like += 1;
      } else {
        videoModel.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      print(e);
    }
  }

  ///取消点赞
  void _onUnLike() {}

  ///收藏
  void _onFavorite() async {
    try {
      var result =
          await FavoriteDao.favorite(videoModel.vid, !videoDetailMo.isFavorite);
      print(result);
      videoDetailMo.isFavorite = !videoDetailMo.isFavorite;
      if (videoDetailMo.isFavorite) {
        videoModel.favorite += 1;
      } else {
        videoModel.favorite -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      print(e);
    }
  }

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }
}
