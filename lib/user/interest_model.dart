import 'package:new_friends_date_app/user/userData_model.dart';

class InterestModel {
  bool? success;
  List<InterestData>? data;
  InterestModel({this.success, this.data});

  InterestModel.fromJson(dynamic json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <InterestData>[];
      json['data'].forEach((v) {
        data!.add(InterestData.fromJson(v));
      });
    }
  }
}

class InterestData {
  String? id;
  String? name;
  String? icon;
  List<FbUserData> list = [];
  InterestData({this.id, this.name, this.icon});

  InterestData.fromJson(dynamic json) {
    id = json['id'].toString();
    name = json['name'];
    icon = json['icon'];
  }
}
