import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/splash_screen/splash_screen.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Future<void> startTimer() async {
    await Future.wait([
      fetchApi(
        url: 'get_industries',
        isloaderShow: false,
        get: true,
        onSucess: (val) {
          val['data'].forEach((e) {
            interestData.add(InterestData.fromJson(e));
          });
        },
      ),
      fetchApi(url: 'get_type_of_listner', get: true, isloaderShow: false)
          .then((value) {
        for (var e in (value['data'] as List)) {
          lsData.add(InterestData.fromJson(e));
        }
      }),
    ]);

    Timer(const Duration(milliseconds: 1500), () async {
      setState(() {
        try {
          if (box.get('isLogedIn') ?? false) {
            dio.options.headers["Authorization"] = 'Bearer ${box.get('t')}';
            fetchApi(
              url: 'get_profile/${box.get('userId')}',
              get: true,
              onSucess: (val) {
                log(val.toString());
                userData = UserData.fromJson(val).data;
                box.put('profileImage', userData!.photos![0]);
              },
            ).then((val) async {
              String? fcmToken = await FirebaseMessaging.instance.getToken();
              log('fcm_token --> $fcmToken');
              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(box.get('phone').toString())
                  .update({
                'online': true,
                'role': val['data']['role'].toString(),
                'fcm_token': fcmToken,
                'wallet': val['data']['wallet_credit_amount'].toString(),
                'earn_wallet': val['data']['earn_wallet_credit'].toString(),
                'interest': val['data']['industry_id'].toString(),
                'on_call': false
              }).then((value) {
                Get.offAll(() => Home());
              });
            });
          } else {
            Get.offAll(const SplashScreen());
          }
        } catch (e) {
          Get.offAll(const SplashScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/logo_white.png"),
                      colorFilter: ColorFilter.mode(
                          Colors.transparent, BlendMode.darken))),
            ),
          ),
        ));
  }
}
