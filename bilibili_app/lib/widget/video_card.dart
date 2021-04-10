import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/navigator_manager.dart';
import 'package:bilibili_app/utils/format_util.dart';
import 'package:bilibili_app/utils/view_util.dart';
import 'package:flutter/material.dart';

///视频卡片
class VideoCard extends StatelessWidget {
  final VideoModel videoMo;

  const VideoCard({Key key, this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        //使用 InkWell是为了使用它的点击事件
        onTap: () {
          print(videoMo.url);
          NavigatorManager.getInstance()
              .onJumpTo(RouteStatus.detail, args: {"videoMo": videoMo});
        },
        child: SizedBox(
          height: 200,
          child: Card(
            //卡片控件
            //取消卡片默认边距
            margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_itemImage(context), _infoText()],
              ),
            ),
          ),
        ));
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(videoMo.cover, width: size.width / 2 - 10, height: 120),
        Positioned(
            //控件位于底部
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
              decoration: BoxDecoration(
                  //设置样式，注意不能和color 一起使用，这样会报错
                  //渐变
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoMo.view),
                  _iconText(Icons.favorite_border, videoMo.favorite),
                  _iconText(null, videoMo.duration),
                ],
              ),
            ))
      ],
    );
  }

  ///图片和文字组合的widget
  _iconText(IconData iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoMo.duration);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(views,
                style: TextStyle(color: Colors.white, fontSize: 10)))
      ],
    );
  }

  /// 底部的视频信息
  _infoText() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoMo.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          //作者
          _owner()
        ],
      ),
    ));
  }

  _owner() {
    var owner = videoMo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: cachedImage(owner.face, height: 24, width: 24)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner.name,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            )
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
