import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class MoveToListner extends StatefulWidget {
  const MoveToListner({super.key});

  @override
  State<MoveToListner> createState() => _MoveToListnerState();
}

class _MoveToListnerState extends State<MoveToListner> {
  int callType = 0;
  String? selectedId;
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
            if (selectedId != null) {
              HomeController _ = Get.find();
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(userData!.phoneNumber!)
                  .update({
                'role': 'listner',
                'availableFor': callType.toString(),
                'listenerTopic': selectedId
              });
              userData!.role = 'listner';

              _.listnerIntData =
                  lsData.firstWhere((element) => element.id == selectedId);
              _.update();
              fetchApi(url: 'move_to_user', params: {
                'user_id': userData!.id,
                'role': 'listner',
                'availablefor': callType.toString(),
                'availablity': selectedId
              }).then((value) => Get.back());
            } else {
              EasyLoading.showToast('Please Select Listener Category',
                  toastPosition: EasyLoadingToastPosition.bottom);
            }
          },
              radius: 30,
              padding: const EdgeInsets.all(14),
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: lsData.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            ctext('Move To Listener',
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: AppColors.mainColor),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ctext('Find People With The Same Interest As Yours',
                          color: AppColors.gText.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 6,
                        children: lsData
                            .map((e) => Column(
                                  children: [
                                    cBounce(
                                      onPressed: () {
                                        setState(() {
                                          selectedId = e.id;
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: selectedId != e.id
                                            ? AppColors.gText.withOpacity(0.5)
                                            : AppColors.mainColor,
                                        child: CircleAvatar(
                                          radius: selectedId != e.id ? 39 : 37,
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: cImage(
                                              e.icon!,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    ctext(e.name!,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)
                                  ],
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      cBounce(
                        onPressed: () {
                          setState(() {
                            callType = 2;
                          });
                        },
                        child: cCard(
                            border: true,
                            borderColor: callType != 2
                                ? AppColors.gText.withOpacity(0.2)
                                : AppColors.mainColor,
                            borderWidth: callType != 2 ? null : 2.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/video_call_color.png',
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ctext('Video Call',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.splashText),
                                  const Spacer(),
                                  Radio(
                                    value: 2,
                                    activeColor: AppColors.mainColor,
                                    groupValue: callType,
                                    onChanged: (value) {
                                      setState(() {
                                        callType = value!;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      cBounce(
                        onPressed: () {
                          callType = 1;
                          setState(() {});
                        },
                        child: cCard(
                            border: true,
                            borderColor: callType != 1
                                ? AppColors.gText.withOpacity(0.2)
                                : AppColors.mainColor,
                            borderWidth: callType != 1 ? null : 2.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/audio_call_color.png',
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ctext('Audio Call',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.splashText),
                                  const Spacer(),
                                  Radio(
                                    value: 1,
                                    activeColor: AppColors.mainColor,
                                    groupValue: callType,
                                    onChanged: (value) {
                                      setState(() {
                                        callType = value!;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      cBounce(
                        onPressed: () {
                          callType = 0;
                          setState(() {});
                        },
                        child: cCard(
                            border: true,
                            borderColor: callType != 0
                                ? AppColors.gText.withOpacity(0.2)
                                : AppColors.mainColor,
                            borderWidth: callType != 0 ? null : 2.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/both_call_color.png',
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ctext('Both (Video/Audio)',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.splashText),
                                  const Spacer(),
                                  Radio(
                                    value: 0,
                                    activeColor: AppColors.mainColor,
                                    groupValue: callType,
                                    onChanged: (value) {
                                      setState(() {
                                        callType = value!;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  )
                : const SizedBox()),
      ),
    );
  }
}
