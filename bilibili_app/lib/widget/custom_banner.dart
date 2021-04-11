import 'package:bilibili_app/model/home_model.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/navigator_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 自己封装的轮播图
class CustomBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry padding;

  const CustomBanner(this.bannerList,
      {Key key, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        //每一页 轮播图的内容
        return _image(bannerList[index]);
      },
      pagination: SwiperPagination(
          //自定义指示器
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
    );
  }

  _image(BannerModel bannerModel) {
    return InkWell(
      onTap: () {
        print(bannerModel.title);
        _handleClick(bannerModel);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(bannerModel.cover, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void _handleClick(BannerModel bannerMo) {
    if (bannerMo.type == 'video') {
      NavigatorManager.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoModel(vid: bannerMo.url)});
    } else {
      print('type:${bannerMo.type} ,url:${bannerMo.url}');
      //todo
    }
  }
}

///banner点击跳转
void handleBannerClick(BannerModel bannerMo) {
  if (bannerMo.type == 'video') {
    NavigatorManager.getInstance().onJumpTo(RouteStatus.detail,
        args: {"videoMo": VideoModel(vid: bannerMo.url)});
  } else {
    NavigatorManager.getInstance().openH5(bannerMo.url);
  }
}
