import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/call/audio_call_screen.dart';
import 'package:new_friends_date_app/call/video_call_screen.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/chat/api/apis.dart';
import 'package:new_friends_date_app/screens/chat/models/chat_user.dart';
import 'package:new_friends_date_app/screens/chat/screens/chat_screen.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/age_from_birthdate.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_dropdown.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';
import 'package:new_friends_date_app/widget/sub_widgets/interest.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class OtherProfile extends StatelessWidget {
  String id;
  OtherProfile({super.key, required this.id});
  // final OtherProfileController _ = Get.put();

  TextEditingController reportText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.delete<OtherProfileController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.scafflodBackground,
        body: SingleChildScrollView(
          child: GetBuilder<OtherProfileController>(
            init: OtherProfileController(id),
            builder: (_) {
              return _.otherUserData != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12 + 24, bottom: 24, left: 24, right: 24),
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
                                    backgroundColor:
                                        AppColors.scafflodBackground,
                                    child: Image.asset(
                                      'assets/icons/back.png',
                                      width: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ctext('Profile',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: AppColors.mainColor),
                              // const SizedBox(
                              //   width: 36,
                              // ),
                              const Spacer(),
                              PopupMenuButton<int>(
                                onSelected: (item) {
                                  if (item == 0) {
                                    fetchApi(url: 'block_user', params: {
                                      'user_id': userData!.id.toString(),
                                      'block_user_id':
                                          _.otherUserData!.id.toString()
                                    }).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(userData!.phoneNumber.toString())
                                          .update({
                                        'blockedByMe': FieldValue.arrayUnion(
                                            [_.otherUserData!.id.toString()])
                                      });
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_.otherUserData!.id.toString())
                                          .update({
                                        'blockedBy': FieldValue.arrayUnion(
                                            [userData!.id.toString()])
                                      }).then((value) {
                                        Get.offAll(() => Home());
                                      });
                                    });
                                  } else {
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
                                                  Icons.report_problem_rounded,
                                                  color: AppColors.mainColor,
                                                  size: 48,
                                                ),
                                                ctext('Report User',
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                cDropDown(
                                                  hintText: "   Select Reason",
                                                  items: [
                                                    'It\'s Spam',
                                                    'Nudity or sexual activity',
                                                    'Hate speech or symbols',
                                                    'False information',
                                                    'Bullying or harassment',
                                                    'Scam or fraud',
                                                    'Violence or dangerous organisations',
                                                    'Intellectual property violation',
                                                    'Sale or illegal or regulated goods'
                                                  ],
                                                  onChanged: (val) {
                                                    List tmpList = [
                                                      'It\'s Spam',
                                                      'Nudity or sexual activity',
                                                      'Hate speech or symbols',
                                                      'False information',
                                                      'Bullying or harassment',
                                                      'Scam or fraud',
                                                      'Violence or dangerous organisations',
                                                      'Intellectual property violation',
                                                      'Sale or illegal or regulated goods'
                                                    ];
                                                    _.selectedReason =
                                                        tmpList[val!];
                                                    _.update();
                                                  },
                                                ),
                                                const SizedBox(height: 12),
                                                cCard(
                                                  border: true,
                                                  borderColor:
                                                      AppColors.mainColor,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: cTextFieldCommon(
                                                      controller: reportText,
                                                      hint: 'Reason for Report',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    cButton('Report',
                                                        onTap: () {
                                                      _.selectedReason != null
                                                          ? fetchApi(
                                                              url:
                                                                  'report_user',
                                                              params: {
                                                                  'user_id':
                                                                      userData!
                                                                          .id,
                                                                  'report_user_id': _
                                                                      .otherUserData!
                                                                      .id
                                                                      .toString(),
                                                                  'text':
                                                                      'User --> ${_.selectedReason!} : ${reportText.text}'
                                                                }).then(
                                                              (value) {
                                                              Get.back();
                                                              Get.offAll(
                                                                  () => Home());
                                                            })
                                                          : EasyLoading.showError(
                                                              'Please Select Appropriate Reason for Reporting User');
                                                    },
                                                        txtColor: Colors.black,
                                                        btnColor: Colors.grey
                                                            .withOpacity(0.5)),
                                                    cButton(
                                                      'Cancel',
                                                      onTap: () {
                                                        Get.back();
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
                                  }
                                },
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context) => [
                                  const PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.block_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text('Block'),
                                        ],
                                      )),
                                  const PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.report_gmailerrorred_rounded,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text('Report'),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _.otherUserData != null
                            ? CarouselSlider(
                                carouselController: _.cc,
                                items: _.otherUserData!.photos!
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: cCard(
                                              radius: 20,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(e))),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    _.currPhotoIndex = index;
                                    _.update();
                                  },
                                  autoPlay: true, aspectRatio: 1.1,
                                  padEnds: true,
                                  viewportFraction: 1,
                                  // enlargeCenterPage: true,
                                ))
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 24, left: 24, right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: _.otherUserData != null
                                    ? AnimatedSmoothIndicator(
                                        activeIndex: _.currPhotoIndex,
                                        count: _.otherUserData!.photos!.length,
                                        effect: const WormEffect(
                                            dotHeight: 10,
                                            dotWidth: 10,
                                            spacing: 6,
                                            activeDotColor:
                                                AppColors.mainColor),
                                      )
                                    : const SizedBox(),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  ctext(
                                      '${_.otherUserData!.fullName!}, ${ageCalculator(_.otherUserData!.dob!)}',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: AppColors.splashText),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  _.otherUserData!.gender == 'Male' ||
                                          _.otherUserData!.gender == 'male'
                                      ? const Icon(
                                          Icons.male_rounded,
                                          color: AppColors.mainColor,
                                        )
                                      : const Icon(
                                          Icons.female_rounded,
                                          color: AppColors.subColor,
                                        )
                                ],
                              ),
                              Row(
                                children: [
                                  ctext(_.otherUserData!.role!,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  _.otherUserData!.role == 'listner'
                                      ? Image.asset(
                                          'assets/icons/listener.png',
                                          color: Colors.yellow,
                                          height: 14,
                                        )
                                      : Image.asset(
                                          'assets/icons/speaker.png',
                                          color: Colors.orange,
                                          height: 14,
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              ctext('About Us',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.splashText),
                              const SizedBox(
                                height: 6,
                              ),
                              ctext(_.otherUserData!.about ?? '-',
                                  fontSize: 12,
                                  maxLines: 5,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(
                                height: 12,
                              ),
                              ctext('Interest',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.splashText),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _.intData
                                    .map((e) => InterestWidget(e))
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              userData!.role == 'speaker' &&
                                      _.otherUserData!.role != 'speaker'
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ctext('Available For',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: AppColors.splashText),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        GetBuilder<HomeController>(
                                          builder: (c) {
                                            return _.otherUserFbData
                                                            .availableFor ==
                                                        '0' ||
                                                    _.otherUserFbData
                                                            .availableFor ==
                                                        '2'
                                                ? cBounce(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('user')
                                                          .doc(_.otherUserData!
                                                              .phoneNumber
                                                              .toString())
                                                          .get()
                                                          .then((value) {
                                                        if (value['on_call']) {
                                                          EasyLoading.showError(
                                                              'User Is Busy On Another Call Right Now, Please Try Again Later');
                                                        } else if (int.parse(c
                                                                .fbData.wallet
                                                                .toString()) >=
                                                            int.parse(userData!
                                                                .videoCallCoin
                                                                .toString())) {
                                                          getUserJoined('2');
                                                        } else {
                                                          EasyLoading.showError(
                                                              'Low Balance!!!\nPlease Add Some Coin To Your Wallet');
                                                        }
                                                      });
                                                    },
                                                    child: cCard(
                                                        radius: 12,
                                                        color:
                                                            AppColors.mainColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/video_call.png',
                                                                height: 24,
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              ctext(
                                                                  'Video Call',
                                                                  color: Colors
                                                                      .white),
                                                              const Spacer(),
                                                              Image.asset(
                                                                'assets/icons/coin.png',
                                                                height: 16,
                                                              ),
                                                              ctext(
                                                                  ' ${userData!.videoCallCoin}',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                              ctext(' / Min',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                            ],
                                                          ),
                                                        )),
                                                  )
                                                : const SizedBox();
                                          },
                                        ),
                                        _.otherUserFbData.availableFor == '0' ||
                                                _.otherUserFbData
                                                        .availableFor ==
                                                    '2'
                                            ? const SizedBox(
                                                height: 12,
                                              )
                                            : const SizedBox(),
                                        _.otherUserFbData.availableFor == '0' ||
                                                _.otherUserFbData
                                                        .availableFor ==
                                                    '1'
                                            ? cBounce(
                                                onPressed: () {
                                                  HomeController c = Get.find();
                                                  FirebaseFirestore.instance
                                                      .collection('user')
                                                      .doc(_.otherUserData!
                                                          .phoneNumber
                                                          .toString())
                                                      .get()
                                                      .then((value) {
                                                    log('--> ${value['on_call']}');
                                                    if (value['on_call']) {
                                                      EasyLoading.showError(
                                                          'User Is Busy On Another Call Right Now, Please Try Again Later');
                                                    } else if (int.parse(c
                                                            .fbData.wallet
                                                            .toString()) >=
                                                        int.parse(userData!
                                                            .audioCallCoin
                                                            .toString())) {
                                                      getUserJoined('1');
                                                    } else {
                                                      EasyLoading.showError(
                                                          'Low Balance!!!\nPlease Add Some Coin To Your Wallet');
                                                    }
                                                  });
                                                },
                                                child: cCard(
                                                    radius: 12,
                                                    color: AppColors.mainColor,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icons/audio_call.png',
                                                            color: Colors.white,
                                                            height: 24,
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          ctext('Audio Call',
                                                              color:
                                                                  Colors.white),
                                                          const Spacer(),
                                                          Image.asset(
                                                            'assets/icons/coin.png',
                                                            height: 16,
                                                          ),
                                                          ctext(
                                                              ' ${userData!.audioCallCoin}',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                          ctext(' / Min',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            : const SizedBox(),
                                        _.otherUserFbData.availableFor == '3'
                                            ? const Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()))
                                            : const SizedBox(),
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 12,
                              ),
                              cBounce(
                                onPressed: () async {
                                  await APIs.addChatUser(
                                          _.otherUserFbData.phone.toString())
                                      .then((value) {
                                    if (!value) {
                                      EasyLoading.showError(
                                          'Sorry! you can\'t chat with this user');
                                    } else {
                                      Get.to(() => ChatScreen(
                                          user: ChatUser(
                                              blockedBy: [],
                                              about: '',
                                              createdAt: '',
                                              email: _.otherUserFbData.phone
                                                  .toString(),
                                              id: _.otherUserFbData.id
                                                  .toString(),
                                              image: _
                                                  .otherUserFbData.profileUrl
                                                  .toString(),
                                              isOnline:
                                                  _.otherUserFbData.online ??
                                                      false,
                                              lastActive: '',
                                              name: _.otherUserFbData.name
                                                  .toString(),
                                              pushToken: _
                                                  .otherUserFbData.fcmToken
                                                  .toString())));
                                    }
                                  });
                                },
                                child: cCard(
                                    radius: 12,
                                    color: AppColors.mainColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.chat_rounded,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          ctext('Chat', color: Colors.white),
                                          const Spacer(),
                                          ctext(' Free',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Future<void>? getUserJoined(String type) {
    var _ = Get.find<OtherProfileController>();
    fetchApi(url: 'getJoinCall', params: {
      'id': userData!.id.toString(),
      'user_id': _.otherUserData!.id.toString(),
      'channel_name': userData!.phoneNumber.toString(),
      'user_name': userData!.fullName.toString(),
      'duration': '30 Mins'
    }).then((value) => {
          FirebaseFirestore.instance
              .collection('call')
              .doc(userData!.phoneNumber.toString())
              .set({
            'caller': userData!.phoneNumber.toString(),
            'calling_to': _.otherUserData!.phoneNumber.toString(),
            'callType': type,
            'call_status':
                '1', //0: onCall , 1: Trying, 2: Cut, 3: Rejected, 4:Finished
            'agoraToken': value['data']['token'].toString(),
            'channelName': value['data']['channelName'].toString(),
            'profile_image': _.otherUserData!.profileImage.toString(),
            'name': _.otherUserData!.fullName.toString(),
            'totalDuration': '',
            'caller_id': userData!.id.toString(),
            'calling_to_id': _.otherUserData!.id.toString()
          }).then((v) async {
            final pushNotificationPayload = jsonEncode(
              {
                'to': _.otherUserFbData.fcmToken.toString(),
                // 'priority': 'high',
                'data': {
                  'body': '${userData!.fullName.toString()} Is Calling You',
                  'title': type == '2'
                      ? 'Incomming Video Call'
                      : 'Incomming Audio Call',
                  'call_type': type,
                  'caller_username': userData!.fullName.toString(),
                  'agoraToken': value['data']['token'].toString(),
                  'caller_userImage': userData!.profileImage.toString(),
                  'channelName': userData!.phoneNumber.toString(),
                  'caller_userID': userData!.id.toString(),
                  'calling_to_id': _.otherUserData!.id.toString()
                },
                // 'notification': {
                //   // 'body': type == '2'
                //   //     ? 'Incomming Video Call'
                //   //     : 'Incomming Audio Call',
                //   // 'title': '${userData!.fullName.toString()} Is Calling You',
                //   'sound': 'default'
                // },
              },
            );

            final Map<String, String> headers = {
              'Content-Type': 'application/json',
              'authorization':
                  'key=AAAAhugViP8:APA91bHqptefhIYMnauQPNefioInlh5zixfQW2p_Ru1zIbHP3Z5RAhgj3z_igA8nmMb7deZMrn2kbSoOos6WTt9kX77Uijh6Ug1GQgMBHX5-aajawkn3mD2lSYKvOuM5uSF_qKadCImb' // Server key(firebase console => project setting => Cloud Messaging)
            };
            final response = await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                body: pushNotificationPayload,
                headers: headers);
            if (response.statusCode == 200) {
              print('Success');
              Get.to(() => type == '2'
                  ? VideoCallScreen(
                      image: _.otherUserData!.profileImage.toString(),
                      name: _.otherUserData!.fullName.toString(),
                      isBroadcast: true,
                      agoraToken: value['data']['token'].toString(),
                      channelName: value['data']['channelName'].toString(),
                    )
                  : AudioCallScreen(
                      image: _.otherUserData!.profileImage.toString(),
                      name: _.otherUserData!.fullName.toString(),
                      isBroadcast: true,
                      agoraToken: value['data']['token'].toString(),
                      channelName: value['data']['channelName'].toString(),
                    ));
            }
          })
        });
    return null;
  }

  void _handleReport(BuildContext context) {}
}
