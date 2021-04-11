import 'package:bilibili_app/model/video_model.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class RankingModel {
  int total;
  List<VideoModel> list;

  RankingModel({this.total, this.list});

  RankingModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<VideoModel>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(new VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
