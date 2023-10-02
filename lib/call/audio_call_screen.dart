import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

import 'audio_call_controller.dart';

class AudioCallScreen extends StatefulWidget {
  String agoraToken;
  String channelName;
  bool isBroadcast;
  String image;
  String name;

  AudioCallScreen(
      {super.key,
      required this.agoraToken,
      required this.channelName,
      required this.isBroadcast,
      required this.image,
      required this.name});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  @override
  void dispose() {
    log('Audio  Call Cutting --delete Controller ');
    Get.delete<AudioCallController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: GetBuilder<AudioCallController>(
        init: AudioCallController(
            isBroadcast: widget.isBroadcast,
            agoraToken: widget.agoraToken,
            channelName: widget.channelName),
        initState: (_) {},
        builder: (_) {
          return Center(
            child: _.remoteUID != null
                ? Container(
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
                              Row(
                                children: [
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 24, top: 36),
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                              const SizedBox(
                                height: 70,
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
                              ctext('In Call With',
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
                                  color: Colors.white),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 24, right: 24),
                              //   child: Container(
                              //     decoration: const BoxDecoration(
                              //         color: Colors.black38,
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(20))),
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 12, vertical: 6),
                              //       child: Row(
                              //         children: [
                              //           const Icon(
                              //             Icons.circle,
                              //             size: 14,
                              //             color: Colors.red,
                              //           ),
                              //           const SizedBox(
                              //             width: 6,
                              //           ),
                              //           Text(
                              //             _.formatDuration(_.callDuration),
                              //             style: const TextStyle(
                              //                 fontSize: 18,
                              //                 color: Colors.white),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 12,
                              // ),
                              SizedBox(
                                width: dwidth,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    cBounce(
                                      onPressed: () {
                                        _.isMute = !_.isMute;
                                        _.engine.muteLocalAudioStream(_.isMute);
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: !_.isMute
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: Icon(
                                          !_.isMute
                                              ? Icons.mic
                                              : Icons.mic_off_rounded,
                                          color: !_.isMute
                                              ? Colors.white
                                              : Colors.black,
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
                                    cBounce(
                                      onPressed: () {
                                        _.cameraToggle = !_.cameraToggle;
                                        _.engine.setEnableSpeakerphone(
                                            _.cameraToggle);
                                      },
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: !_.cameraToggle
                                            ? Colors.transparent
                                            : Colors.white,
                                        child: Icon(
                                          size: 24,
                                          !_.cameraToggle
                                              ? Icons.volume_up_sharp
                                              : Icons.volume_up_sharp,
                                          color: !_.cameraToggle
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
                  ),
          );
        },
      )),
    );
  }
}
