import 'package:bilibili_app/utils/view_util.dart';
import 'package:flutter/material.dart';

///可动态改变位置的Header组件
///性能优化：局部刷新的应用@刷新原理
class FlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;

  const FlexibleHeader(
      {Key key,
      @required this.name,
      @required this.face,
      @required this.controller})
      : super(key: key);

  @override
  _FlexibleHeaderState createState() => _FlexibleHeaderState();
}

class _FlexibleHeaderState extends State<FlexibleHeader> {
  static const double MAX_BOTTOM = 40;
  static const double MIN_BOTTOM = 10;

  //滚动范围
  static const MAX_OFFSET = 80;
  double _dyBottom = MAX_BOTTOM;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var offset = widget.controller.offset;
      print('offset:$offset');
      //算出padding变化系数0-1
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      //根据dyOffset算出具体的变化的padding值
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
      //临界值保护
      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }
      setState(() {
        //算出实际的padding
        _dyBottom = MIN_BOTTOM + dy;
      });
      print('_dyBottom:$_dyBottom');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(widget.face, width: 46, height: 46),
          ),
          customSpace(width: 8),
          Text(
            widget.name,
            style: TextStyle(fontSize: 11, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
