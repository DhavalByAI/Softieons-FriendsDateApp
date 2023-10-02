import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/auth/signup_controller.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/age_from_birthdate.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:http/http.dart' as http;

class SignupInterest extends StatelessWidget {
  SignupInterest({super.key});
  final ScrollController _sc = ScrollController();
  final SignUpController _ = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      bottomSheet: Container(
        height: 24 + 50,
        color: AppColors.scafflodBackground,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          child: cButton('Continue', onTap: () {
            if (_.selectedInterest.length == 3) {
              registerAPI().then(
                (value) {
                  if (value) {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      barrierDismissible: false,
                      builder: (context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: Dialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/congratulation.png',
                                    height: 140,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  ctext(
                                      'Your Account has Been\nCreated Successfully',
                                      textAlign: TextAlign.center),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      cButton('Home', onTap: () {
                                        Get.offAll(() => Home());
                                      },
                                          radius: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 12),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            } else {
              EasyLoading.showToast('Please Select Any 3 Interest',
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.bottom);
            }
          },
              radius: 30,
              padding: const EdgeInsets.all(14),
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
        child: SingleChildScrollView(
          controller: _sc,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                ),
                child: Row(
                  children: [
                    cBounce(
                      onPressed: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black26,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.scafflodBackground,
                          child: Image.asset(
                            'assets/icons/back.png',
                            width: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ctext('Select Your Interest',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.mainColor),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              Obx(() => interestData.isNotEmpty
                  ? GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      controller: _sc,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 24,
                      children: List.generate(
                        interestData.length,
                        (index) => cBounce(
                          onPressed: () {
                            _.selectedInterest.contains(interestData[index].id)
                                ? _.selectedInterest
                                    .remove(interestData[index].id)
                                : _.selectedInterest
                                    .add(interestData[index].id.toString());
                          },
                          child: cCard(
                            radius: 16,
                            height: 50,
                            borderWidth: _.selectedInterest
                                    .contains(interestData[index].id)
                                ? 3
                                : 2,
                            borderColor: _.selectedInterest
                                    .contains(interestData[index].id)
                                ? AppColors.mainColor
                                : AppColors.subColor.withOpacity(0.4),
                            border: true,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ctext(interestData[index].name!,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.splashText),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: cImage(interestData[index].icon!),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> registerAPI() async {
    EasyLoading.show();
    // try {
    var request =
        http.MultipartRequest("POST", Uri.parse('${AppConst.baseUrl}register'));
    final List<http.MultipartFile> newList = [];

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    for (int i = 0; i < _.photos.length; i++) {
      if (_.photos[i] != null) {
        final multiImages =
            http.MultipartFile.fromPath('photos[]', _.photos[i]!.path);
        newList.add(await multiImages);
      }
    }
    request.files.addAll(newList);
    String selectedInterestId = '';

    for (var element in _.selectedInterest) {
      selectedInterestId = '$selectedInterestId$element,';
    }

    request.fields['full_name'] = _.name.text;
    request.fields['email'] = _.email.text;
    request.fields['password'] = _.password.text;
    request.fields['phone_number'] = _.phone.text;
    request.fields['dob'] = _.dob.text;
    request.fields['country_id'] = 101.toString();
    request.fields['gender'] = _.selectedGender.value == 0 ? 'Male' : 'Female';
    request.fields['industry_id'] =
        selectedInterestId.substring(0, selectedInterestId.length - 1);
    request.fields['fcm_token'] = fcmToken ?? '';
    request.fields['provider'] = '456';
    request.fields['auth_id'] = '789';
    request.fields['reffered_code'] = '';
    var response = await request.send();
    Map<String, dynamic> val =
        json.decode(await response.stream.bytesToString());
    log(val.toString());
    if (val['success'].toString() == 'true' ||
        val['success'].toString() == 'success') {
      box.put('fcmToken', val['data']['fcm_token']);
      box.put('userId', val['data']['id']);
      box.put('isFirst', false);
      box.put('isLogedIn', true);
      box.put('email', val['data']['email']);
      box.put('phone', val['data']['phone_number']);
      box.put('t', val['token']);
      box.put('password', _.password.text);
      dio.options.headers["Authorization"] = 'Bearer ${val['token']}';
      fetchApi(
        url: 'get_profile/${val['data']['id']}',
        isloaderShow: false,
        get: true,
        onSucess: (val) {
          userData = UserData.fromJson(val).data;
          box.put('profileImage', userData!.photos![0]);
          FirebaseFirestore.instance
              .collection('user')
              .doc(val['data']['phone_number'].toString())
              .set({
            'id': val['data']['id'].toString(),
            'phone': val['data']['phone_number'].toString(),
            'fcm_token': fcmToken.toString(),
            'name': val['data']['full_name'].toString(),
            'profileUrl': val['data']['profile_image'].toString(),
            'online': true,
            'wallet': val['data']['wallet_credit_amount'].toString(),
            'role': val['data']['role'].toString(),
            'earn_wallet': val['data']['earn_wallet_credit'].toString(),
            'interest':
                selectedInterestId.substring(0, selectedInterestId.length - 1),
            'age': ageCalculator(val['data']['dob'].toString()),
            'availableFor': '0',
            'listenerTopic': '1',
            'on_call': false
          });
        },
      );
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError(val['message'].toString());
      return false;
    }

    // } catch (e) {
    //   EasyLoading.showError('Something Went Wrong, Please Try Again');
    //   return false;
    //   // Navigator.pop(context);
    //   // setState(() {
    //   //   Navigator.of(context);
    //   //   ErrorDialouge.showErrorDialogue(context, _keyError, e.toString());
    //   //   print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    //   //   print("Exeption $e");
    //   // });
    // }
  }
}
