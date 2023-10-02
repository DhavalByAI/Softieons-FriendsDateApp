import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:dio/dio.dart';

Data? userData = UserData().data;
double kPadding = 24;
const int bounceDuration = 150;
double? dheight = Get.height;
double? dwidth = Get.width;
final dio = Dio();
var box = Hive.box('myBox');
List<InterestData> interestData = <InterestData>[];
List<InterestData> lsData = [];
String kRupee = '₹';

class AppConst {
  static const String baseUrl = "https://softieons.in/dating-fdl/api/";
  static const String agoraAppID = "b8761104b178437f8e37b989f1cc9f1a";
}
