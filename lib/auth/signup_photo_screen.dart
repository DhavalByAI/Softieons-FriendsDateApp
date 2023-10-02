import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/auth/signup_controller.dart';
import 'package:new_friends_date_app/auth/signup_intrest.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSelectionScreen extends StatelessWidget {
  PhotoSelectionScreen({super.key});
  final ImagePicker picker = ImagePicker();
  final SignUpController _ = Get.put(SignUpController(), permanent: true);
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
            _.photos[0] != null
                ? Get.to(
                    () => SignupInterest(),
                    transition: Transition.rightToLeft,
                  )
                : EasyLoading.showToast('Please Select Profile Picture',
                    dismissOnTap: true,
                    toastPosition: EasyLoadingToastPosition.bottom);
          },
              radius: 30,
              padding: const EdgeInsets.all(14),
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
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
                  ctext('Add Your Best Photos',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.mainColor),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 175,
              child: Row(
                children: [
                  Expanded(
                    child: cBounce(
                      onPressed: () async {
                        _.photos[0] =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: cCard(
                        child: Obx(
                          () => _.photos[0] == null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Column(
                                    children: [
                                      cCard(
                                        shadow: false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Icon(
                                            Icons.person_add_alt_1_rounded,
                                            size: 60,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      ctext('Add Profile Picture',
                                          color: Colors.black38),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          cCard(
                                              color: AppColors.subColor,
                                              radius: 25,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                    ctext('Add',
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(_.photos[0]!.path)))),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: cBounce(
                      onPressed: () async {
                        _.photos[1] =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: cCard(
                        child: Obx(
                          () => _.photos[1] == null
                              ? cCard(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        cCard(
                                          shadow: false,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                              Icons.add_a_photo_rounded,
                                              size: 60,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(_.photos[1]!.path)))),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 175,
              child: Row(
                children: [
                  Expanded(
                    child: cBounce(
                      onPressed: () async {
                        _.photos[2] =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: cCard(
                        child: Obx(
                          () => _.photos[2] == null
                              ? cCard(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        cCard(
                                          shadow: false,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                              Icons.add_a_photo_rounded,
                                              size: 60,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(_.photos[2]!.path)))),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: cBounce(
                      onPressed: () async {
                        _.photos[3] =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: cCard(
                        child: Obx(
                          () => _.photos[3] == null
                              ? cCard(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        cCard(
                                          shadow: false,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                              Icons.add_a_photo_rounded,
                                              size: 60,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(_.photos[3]!.path)))),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
