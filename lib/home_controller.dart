import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/utils/change_status.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/chat/api/apis.dart';
import 'user/userData_model.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        log('detached');
        changeStatus(0);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    EasyLoading.dismiss();
    WidgetsBinding.instance.addObserver(this);
    matchData = lsData;
    takePermission();
    updateData();

    FirebaseFirestore.instance.collection("user").snapshots().listen(
      (event) {
        log('updating..');
        listOfUser =
            event.docs.map((e) => FbUserData.fromJson(e.data())).toList();
        fbData = (listOfUser.firstWhere(
            (element) => element.id.toString() == userData!.id.toString()));
        List tmpBlockedList = [];
        for (var element in listOfUser) {
          fbData.blockedByMe?.forEach((e) {
            e.toString() == element.id.toString()
                ? tmpBlockedList.add(element)
                : null;
          });
        }

        for (var element in tmpBlockedList) {
          listOfUser.remove(element);
        }

        for (var element in intData) {
          element.list.clear();
        }
        for (var element in matchData) {
          element.list.clear();
        }

        update();
        for (var user in listOfUser) {
          if ((user.role.toString() == 'listner') && (user.online ?? false)) {
            for (var element in matchData) {
              element.id.toString() == user.listenerTopic.toString()
                  ? element.list.add(user)
                  : null;
            }
          }
          update();
          getInt(user).then((value) {
            var userInterst =
                user.interest?.removeAllWhitespace.split(",").toList() ?? [];

            for (var element in userInterst) {
              for (var val in intData) {
                val.id.toString() == element.toString()
                    ? val.list.firstWhereOrNull((j) => (j.id == user.id)) !=
                            null
                        ? null
                        : user.id.toString() != userData!.id.toString()
                            ? val.list.add(user)
                            : null
                    : null;
              }
            }
          });
        }
        update();
      },
    );
    update();
  }

  Future<bool> getInt(FbUserData user) async {
    if (user.id.toString() == userData!.id.toString()) {
      fbData = user;
      listnerIntData =
          lsData.firstWhere((element) => element.id == fbData.listenerTopic);

      if (fbData.interest != null) {
        var userInterstD = fbData.interest?.split(",").toList() ?? [];

        intData.clear();
        for (var j in userInterstD) {
          var found = interestData.firstWhereOrNull((e) => e.id == j);
          if (found != null) {
            intData.add(found);
          }
        }
      }
      update();
    }
    return true;
  }

  Future<void> takePermission() async {
    await [Permission.microphone, Permission.camera, Permission.notification]
        .request()
        .then((value) {});
  }

  List<InterestData> matchData = [];
  AdvancedDrawerController drawerController = AdvancedDrawerController();
  FbUserData fbData = FbUserData();
  List banner = [];
  List<InterestData> intData = [];
  InterestData listnerIntData = InterestData();
  List<Map<String, dynamic>> userListWithStatus = [];
  int currpageIndex = 0;
  List<FbUserData> listOfUser = [];

  updateData() async {
    await Future.wait([
      fetchApi(
        url: 'get_profile/${box.get('userId')}',
        get: true,
        onSucess: (val) {
          userData = UserData.fromJson(val).data;
          APIs.getSelfInfo();
        },
      ).then((val) async {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(box.get('phone').toString())
            .update({
          'role': val['data']['role'].toString(),
          'fcm_token': fcmToken,
          'wallet': val['data']['wallet_credit_amount'].toString(),
          'earn_wallet': val['data']['earn_wallet_credit'].toString(),
          'interest': val['data']['industry_id'].toString(),
          'on_call': false
        });
      }),
      fetchApi(
        url: 'get_banner',
        get: true,
        onSucess: (val) {
          val['data'].forEach((e) {
            banner.add(e['image']);
            update();
          });
        },
      ),
      changeStatus(1),
    ]);
  }
}
