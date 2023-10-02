import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';
import 'package:permission_handler/permission_handler.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgetPassword = TextEditingController();
  String? fcmToken;
  init() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    await permission();
  }

  permission() async {
    await [
      Permission.microphone,
      Permission.camera,
      Permission.storage,
      Permission.notification,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            child: Image.asset(
              'assets/images/splash2.png',
              width: dwidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            // bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cCard(
                      shadow: false,
                      color: AppColors.subColor.withOpacity(0.1),
                      border: true,
                      borderColor: AppColors.subColor,
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.gText,
                              size: 16,
                            ),
                            ctext(
                              'It\'s Not A Dating App',
                              color: AppColors.gText,
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: kPadding,
                  ),
                  cTextField(
                      title: 'Enter Email/Phone Number',
                      textField: cTextFieldCommon(
                        controller: email,
                        hint: 'robert_downy@gmail.com',
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  cTextField(
                      title: 'Enter Password',
                      textField: cTextFieldCommon(
                        controller: password,
                        obscureText: true,
                        hint: 'Abcd@1234',
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cBounce(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.password_rounded,
                                          color: AppColors.mainColor,
                                          size: 48,
                                        ),
                                        ctext('Forget Password',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        cCard(
                                          border: true,
                                          borderColor: AppColors.mainColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: cTextFieldCommon(
                                              controller: forgetPassword,
                                              hint: 'Enter Your Email Address',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            cButton('Cancel', onTap: () {
                                              Get.back();
                                            },
                                                txtColor: Colors.black,
                                                btnColor: Colors.grey
                                                    .withOpacity(0.5)),
                                            cButton(
                                              'Send Link',
                                              onTap: () {
                                                fetchApi(
                                                    url: 'forget_password',
                                                    params: {
                                                      'email':
                                                          forgetPassword.text
                                                    }).then((value) {
                                                  Get.back();
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: ctext('Forget Password?',
                              color: AppColors.mainColor)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  cButton('Login', onTap: () {
                    if (email.text.isNotEmpty && password.text.isNotEmpty) {
                      fetchApi(
                        url: 'login',
                        params: {
                          'phone_number': email.text,
                          'password': password.text,
                          'fcm_token': fcmToken ?? '',
                        },
                        onSucess: (val) {
                          box.put('fcmToken', val['data']['fcm_token']);
                          box.put('userId', val['data']['id']);
                          box.put('isFirst', false);
                          box.put('isLogedIn', true);
                          box.put('phone', val['data']['phone_number']);
                          box.put('email', val['data']['email']);
                          box.put('t', val['data']['token']);
                          box.put('password', password.text);
                          dio.options.headers["Authorization"] =
                              'Bearer ${val['data']['token']}';
                          fetchApi(
                            url: 'get_profile/${val['data']['id']}',
                            get: true,
                            onSucess: (val) {
                              userData = UserData.fromJson(val).data;
                              box.put('profileImage', userData!.photos![0]);
                            },
                          ).then((value) {
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(val['data']['phone_number'].toString())
                                .update({
                              'device_token': fcmToken.toString(),
                              'online': true,
                              'role': val['data']['role'].toString(),
                              'wallet': val['data']['wallet_credit_amount']
                                  .toString(),
                              'earn_wallet':
                                  val['data']['earn_wallet_credit'].toString(),
                              'interest': val['data']['industry_id'].toString(),
                              'on_call': false
                            }).then((value) {
                              Get.offAll(() => Home());
                            });
                          });
                        },
                      );
                    } else {
                      EasyLoading.showToast(
                          'Please Enter Valid Email/Phone Number Or Password');
                    }
                  },
                      radius: 30,
                      padding: const EdgeInsets.all(14),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ctext('Don\'t have any account ? ',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.splashText),
                      cBounce(
                        onPressed: () {
                          Get.to(() => const SignupScreen(),
                              curve: Curves.bounceInOut);
                        },
                        child: ctext(
                          'sign up ',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
