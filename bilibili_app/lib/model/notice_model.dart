import 'package:bilibili_app/model/home_model.dart';

class NoticeModel {
  int total;
  List<BannerModel> list;

  NoticeModel({this.total, this.list});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<BannerModel>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(new BannerModel.fromJson(v));
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
