import 'package:bilibili_app/model/home_model.dart';
import 'package:bilibili_app/utils/format_util.dart';
import 'package:bilibili_app/utils/view_util.dart';
import 'package:flutter/material.dart';

import 'custom_banner.dart';

///通知列表卡片
class NoticeCard extends StatelessWidget {
  final BannerModel bannerMo;

  const NoticeCard({Key key, @required this.bannerMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleBannerClick(bannerMo);
      },
      child: Container(
        decoration: BoxDecoration(border: borderLine(context)),
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildIcon(), customSpace(width: 10), _buildContents()],
        ),
      ),
    );
  }

  _buildIcon() {
    var iconData = bannerMo.type == 'video'
        ? Icons.ondemand_video_outlined
        : Icons.card_giftcard;
    return Icon(
      iconData,
      size: 30,
    );
  }

  _buildContents() {
    return Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bannerMo.title, style: TextStyle(fontSize: 16)),
            Text(dateMonthAndDay(bannerMo.createTime)),
          ],
        ),
        customSpace(height: 5),
        Text(bannerMo.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis)
      ],
    ));
  }
}
