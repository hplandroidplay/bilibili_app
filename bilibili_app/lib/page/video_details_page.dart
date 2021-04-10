import 'package:bilibili_app/model/video_model.dart';
import 'package:flutter/widgets.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("VideoDetailPage:videoId=${widget.videoModel.vid}"),
    );
  }
}
