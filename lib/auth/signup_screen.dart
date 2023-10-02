import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/auth/login_screen.dart';
import 'package:new_friends_date_app/auth/signup_controller.dart';
import 'package:new_friends_date_app/auth/signup_photo_screen.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController _ = Get.put(SignUpController());
    return Scaffold(
      bottomSheet: Container(
        color: AppColors.scafflodBackground,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 12, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              cButton('Continue', onTap: () {
                if (_.name.text.isNotEmpty &&
                    _.email.text.isNotEmpty &&
                    _.dob.text.isNotEmpty &&
                    _.phone.text.isNotEmpty &&
                    _.password.text.isNotEmpty &&
                    _.cnfmPassword.text.isNotEmpty) {
                  if (_.password.text != _.cnfmPassword.text) {
                    EasyLoading.showToast('Password Does Not Match',
                        toastPosition: EasyLoadingToastPosition.bottom,
                        dismissOnTap: true);
                  } else if (_.phone.text.length != 10) {
                    EasyLoading.showToast('Please Insert Valid Phone Number',
                        toastPosition: EasyLoadingToastPosition.bottom,
                        dismissOnTap: true);
                  } else {
                    Get.to(
                      () => PhotoSelectionScreen(),
                      transition: Transition.rightToLeft,
                    );
                  }
                } else {
                  EasyLoading.showToast('Please Enter Valid Details',
                      toastPosition: EasyLoadingToastPosition.bottom,
                      dismissOnTap: true);
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
                  ctext('Already have an account ? ',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.splashText),
                  cBounce(
                    onPressed: () {
                      Get.offAll(() => const LoginScreen(),
                          curve: Curves.bounceInOut);
                    },
                    child: ctext(
                      'sign in',
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
      ),
      backgroundColor: AppColors.scafflodBackground,
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
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
                      ctext('Create An Account',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.mainColor),
                    ],
                  ),
                ),
                cTextField(
                    title: 'Full Name',
                    textField: cTextFieldCommon(
                      controller: _.name,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(50),
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                      ],
                      hint: 'Robert Downy',
                    )),
                cTextField(
                    title: 'Email Address',
                    textField: cTextFieldCommon(
                      controller: _.email,
                      textInputType: TextInputType.emailAddress,
                      hint: 'robert@gmail.com',
                    )),
                cTextField(
                    title: 'Date Of Birth',
                    textField: cTextFieldCommon(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          if (value != null) {
                            _.dob.text = DateFormat('dd-MM-yyyy').format(value);
                          }
                        });
                      },
                      controller: _.dob,
                      hint: '08/10/199',
                    )),
                cTextField(
                    title: 'Phone Number',
                    textField: cTextFieldCommon(
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textInputType: TextInputType.phone,
                      controller: _.phone,
                      hint: '9123545625',
                    )),
                cTextField(
                    title: 'Password',
                    textField: cTextFieldCommon(
                      obscureText: true,
                      controller: _.password,
                      hint: 'Abcd@1234',
                    )),
                cTextField(
                    title: 'Confirm Password',
                    textField: cTextFieldCommon(
                      obscureText: true,
                      controller: _.cnfmPassword,
                      hint: 'Abcd@1234',
                    )),
                const SizedBox(
                  height: 16,
                ),
                Obx(() => Row(
                      children: [
                        ctext('Gender', fontSize: 14),
                        const SizedBox(
                          width: 14,
                        ),
                        Obx(() => cBounce(
                              onPressed: () {
                                _.selectedGender.value = 0;
                              },
                              child: cCard(
                                border: true,
                                borderColor: _.selectedGender == 0
                                    ? AppColors.mainColor
                                    : AppColors.mainColor.withOpacity(0.5),
                                borderWidth: 2,
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      radius: 5.5,
                                      backgroundColor: _.selectedGender == 0
                                          ? AppColors.mainColor
                                          : Colors.transparent,
                                    )),
                              ),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/icons/male.png',
                          height: 20,
                          color: _.selectedGender == 0
                              ? AppColors.mainColor
                              : AppColors.mainColor.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        ctext('Male',
                            fontSize: 11,
                            color: _.selectedGender == 0
                                ? AppColors.mainColor
                                : AppColors.mainColor.withOpacity(0.5)),
                        const SizedBox(
                          width: 12,
                        ),
                        Obx(() => cBounce(
                              onPressed: () {
                                _.selectedGender.value = 1;
                              },
                              child: cCard(
                                border: true,
                                borderColor: _.selectedGender == 1
                                    ? AppColors.mainColor
                                    : AppColors.mainColor.withOpacity(0.5),
                                borderWidth: 2,
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      radius: 5.5,
                                      backgroundColor: _.selectedGender == 1
                                          ? AppColors.mainColor
                                          : Colors.transparent,
                                    )),
                              ),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/icons/female.png',
                          height: 20,
                          color: _.selectedGender == 1
                              ? AppColors.mainColor
                              : AppColors.mainColor.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        ctext('Female',
                            fontSize: 11,
                            color: _.selectedGender == 1
                                ? AppColors.mainColor
                                : AppColors.mainColor.withOpacity(0.5)),
                      ],
                    )),
                const SizedBox(
                  height: 110,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
