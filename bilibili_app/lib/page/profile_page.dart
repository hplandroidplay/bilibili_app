import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/profile_dao.dart';
import 'package:bilibili_app/model/profile_model.dart';
import 'package:bilibili_app/utils/toast.dart';
import 'package:bilibili_app/utils/view_util.dart';
import 'package:bilibili_app/widget/benefit_card.dart';
import 'package:bilibili_app/widget/course_card.dart';
import 'package:bilibili_app/widget/custom_banner.dart';
import 'package:bilibili_app/widget/custom_blur.dart';
import 'package:bilibili_app/widget/flexible_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///我的
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileModel _profileMo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_buildAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
        ),
      ),
    );
  }

  void _loadData() async {
    try {
      ProfileModel result = await ProfileDao.get();
      print(result);
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return FlexibleHeader(
        name: _profileMo.name, face: _profileMo.face, controller: _controller);
  }

  @override
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      //扩展高度
      expandedHeight: 160,
      //标题栏是否固定
      pinned: true,
      //定义滚动空间
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax, // 向上滑动 title 的样式，一起滑动出去、停留在顶部
        titlePadding: EdgeInsets.only(left: 0),
        title: _buildHead(), // title 的widget
        background: Stack(
          //背景
          children: [
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            Positioned.fill(child: CustomBlur(sigma: 20)),
            Positioned(bottom: 0, left: 0, right: 0, child: _buildProfileTab())
          ],
        ),
      ),
    );
  }

  _buildContentList() {
    if (_profileMo == null) {
      return [];
    }
    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo.courseList),
      BenefitCard(benefitList: _profileMo.benefitList),
    ];
  }

  ///轮播图
  _buildBanner() {
    return CustomBanner(_profileMo.bannerList,
        bannerHeight: 120, padding: EdgeInsets.only(left: 10, right: 10));
  }

  /// head 的底部
  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileMo.favorite),
          _buildIconText('点赞', _profileMo.like),
          _buildIconText('浏览', _profileMo.browsing),
          _buildIconText('金币', _profileMo.coin),
          _buildIconText('粉丝', _profileMo.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
