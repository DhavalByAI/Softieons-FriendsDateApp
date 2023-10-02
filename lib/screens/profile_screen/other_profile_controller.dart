import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';

class OtherProfileController extends GetxController {
  OtherProfileController(this.id);
  String id;
  @override
  void onClose() {
    otherUserData = UserData().data;
    cc = CarouselController();
    super.onClose();
  }

  CarouselController cc = CarouselController();
  Data? otherUserData;
  String? selectedReason;
  int currPhotoIndex = 0;
  List<InterestData> intData = [];
  FbUserData otherUserFbData = FbUserData();
  data() {
    fetchApi(url: 'get_profile/$id', get: true).then((value) async {
      log('--->$value');
      if (value != 'error' && value != null) {
        otherUserData = UserData.fromJson(value).data;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(otherUserData!.phoneNumber)
            .get()
            .then(
          (value) {
            otherUserFbData = FbUserData.fromJson(value.data()!);
            update();
          },
        );
        if (otherUserData!.industryId != null) {
          var userInterst =
              otherUserData!.industryId?.split(",").toList() ?? [];
          intData.clear();
          for (var element in userInterst) {
            var found = interestData.firstWhereOrNull((e) => e.id == element);
            if (found != null) {
              intData.add(found);
            }
          }
          update();
        }
        update();
      } else {
        FirebaseFirestore.instance.collection('user').get().then((value) {
          for (var element in value.docs) {
            element['id'].toString() == id
                ? FirebaseFirestore.instance
                    .collection('user')
                    .doc(element['phone'])
                    .delete()
                : null;
          }
        });
        Get.back();
        EasyLoading.showInfo("User Data Not Found!");
      }
    });
  }

  @override
  void onInit() {
    data();
    super.onInit();
  }
}
