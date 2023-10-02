import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/call/video_call_controller.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class VideoCallScreen extends StatefulWidget {
  String agoraToken;
  String channelName;
  bool isBroadcast;
  String image;
  String name;

  VideoCallScreen(
      {super.key,
      required this.agoraToken,
      required this.channelName,
      required this.isBroadcast,
      required this.image,
      required this.name});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  void dispose() {
    log('Video  Call Cutting --delete Controller ');
    Get.delete<VideoCallController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: WithForegroundTask(
        child: Scaffold(
            body: GetBuilder<VideoCallController>(
          init: VideoCallController(
              isBroadcast: widget.isBroadcast,
              agoraToken: widget.agoraToken,
              channelName: widget.channelName),
          initState: (_) {},
          builder: (_) {
            return Stack(
              children: [
                Center(
                  child: _remoteVideo(),
                ),
                _.remoteUID != null
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cCard(
                              width: 100,
                              height: 150,
                              child: Center(
                                child: _.localUserJoined
                                    ? AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: _.engine,
                                          canvas: const VideoCanvas(uid: 0),
                                        ),
                                      )
                                    : const CircularProgressIndicator(),
                              ),
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 24, top: 36),
                                  child: cBounce(
                                    child: cCard(
                                      radius: 20,
                                      // border: true,
                                      // borderColor: AppColors.mainColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 4),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/coin.png',
                                              height: 22,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            GetBuilder<HomeController>(
                                              initState: (_) {},
                                              builder: (_) {
                                                return ctext(
                                                    _.fbData.role == 'speaker'
                                                        ? _.fbData.wallet
                                                            .toString()
                                                            .replaceAll(
                                                                ".00", "")
                                                        : _.fbData.earnWallet
                                                            .toString()
                                                            .replaceAll(
                                                                ".00", ""),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.splashText);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          },
        )),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return GetBuilder<VideoCallController>(
      initState: (_) {},
      builder: (_) {
        return _.remoteUID != null
            ? Stack(
                children: [
                  AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _.engine,
                      canvas: VideoCanvas(uid: _.remoteUID),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     CircleAvatar(
                        //       radius: 14,
                        //       backgroundImage: NetworkImage(image),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(
                        //           left: 8, right: 24, bottom: 12),
                        //       child: ctext(name,
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.w700,
                        //           color: Colors.white),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          width: dwidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          _.formatDuration(_.callDuration),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 48),
                                child: cBounce(
                                    onPressed: () async {
                                      _.isBeuty = !_.isBeuty;
                                      _.isBeuty
                                          ? await _.engine
                                              .setBeautyEffectOptions(
                                                  enabled: true,
                                                  options: const BeautyOptions(
                                                      sharpnessLevel: 1,
                                                      rednessLevel: 1,
                                                      lighteningLevel: 1,
                                                      smoothnessLevel: 1))
                                          : await _.engine
                                              .setBeautyEffectOptions(
                                                  enabled: true,
                                                  options: const BeautyOptions(
                                                      sharpnessLevel: 0,
                                                      rednessLevel: 0,
                                                      lighteningLevel: 0,
                                                      smoothnessLevel: 0));
                                      _.update();
                                    },
                                    child: Image.asset(
                                      _.isBeuty
                                          ? 'assets/icons/beuty_on.png'
                                          : 'assets/icons/beuty_off.png',
                                      height: 24,
                                      width: 24,
                                    )
                                    // Icon(
                                    //   _.isBeuty
                                    //       ? Icons.camera_enhance_rounded
                                    //       : Icons.camera_enhance_outlined,
                                    //   color: Colors.white,
                                    // ),
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: dwidth,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _.isMute = !_.isMute;
                                  _.engine.muteLocalAudioStream(_.isMute);
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: !_.isMute
                                      ? Colors.transparent
                                      : Colors.black26,
                                  child: Icon(
                                    !_.isMute
                                        ? Icons.mic
                                        : Icons.mic_off_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              cBounce(
                                onPressed: () {
                                  EasyLoading.show();
                                  _.callEndFunction();
                                },
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.call_end,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _.cameraToggle = !_.cameraToggle;
                                  _.engine.switchCamera();
                                },
                                child: CircleAvatar(
                                  backgroundColor: !_.cameraToggle
                                      ? Colors.transparent
                                      : Colors.black26,
                                  child: Image.asset(
                                      'assets/icons/cam_switch.png',
                                      height: 26,
                                      width: 26),
                                  // Icon(
                                  //   !_.cameraToggle
                                  //       ? Icons.camera_front_rounded
                                  //       : Icons.camera_rear_rounded,
                                  //   color: Colors.white,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Container(
                height: dheight,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/call_bg.png',
                        ),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          cBounce(
                            child: CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(widget.image),
                                radius: 64,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ctext(
                              widget.isBroadcast
                                  ? 'Calling...'
                                  : 'Connecting...',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white

                              // textAlign: TextAlign.center,
                              ),
                          const SizedBox(
                            height: 8,
                          ),
                          ctext(widget.name,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: cBounce(
                          onPressed: () {
                            EasyLoading.show();
                            _.callEndFunction();
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.call_end,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
