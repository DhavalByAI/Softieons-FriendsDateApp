import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';

class VideoCallController extends GetxController with WidgetsBindingObserver {
  String channelName;
  String agoraToken;
  bool isBroadcast;
  VideoCallController({
    required this.isBroadcast,
    required this.agoraToken,
    required this.channelName,
  });
  final HomeController _ = Get.put(HomeController());

  final player = AudioPlayer();

  var listner;
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('inActive');
        // callEndFunction();
        break;
      case AppLifecycleState.resumed:
        log('resumed');
        // callEndFunction();
        break;
      case AppLifecycleState.paused:
        log('paused');
        // callEndFunction();
        break;
      case AppLifecycleState.detached:
        callEndFunction();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  playRing() async {
    // const androidConfig = FlutterBackgroundAndroidConfig(
    //   notificationTitle: "flutter_background example app",
    //   notificationText:
    //       "Background notification for keeping the example app running in the background",
    //   notificationImportance: AndroidNotificationImportance.Default,
    //   notificationIcon: AndroidResource(
    //       name: 'background_icon',
    //       defType: 'drawable'), // Default is ic_launcher from folder mipmap
    // );

    // await FlutterBackground.initialize(androidConfig: androidConfig);
    // await FlutterBackground.initialize(androidConfig: androidConfig);
    // await FlutterBackground.initialize(androidConfig: androidConfig);
    // await FlutterBackground.initialize(androidConfig: androidConfig);
    // await FlutterBackground.initialize(androidConfig: androidConfig);

    // await FlutterBackground.hasPermissions;
    // await FlutterBackground.enableBackgroundExecution();
    startForegroundService();
    if (isBroadcast) {
      final duration = await player.setAsset('assets/ringtone/ring.wav');
      player.setLoopMode(LoopMode.one);
      player.play();
    }
  }

  void startForegroundService() async {
    ForegroundService().start();
    debugPrint("Started service");
  }

  @override
  void onClose() async {
    listner.cancel();
    EasyLoading.dismiss();
    isBroadcast
        ? FirebaseFirestore.instance
            .collection("call")
            .doc(channelName)
            .get()
            .then((value) async {
            if (value.data() != null) {
              await FirebaseFirestore.instance
                  .collection("call")
                  .doc(channelName)
                  .delete();

              if (isEverCallJoined && isBroadcast) {
                fetchApi(url: 'callEndSession', params: {
                  'caller_id': userData!.id.toString(),
                  'receiver_id': receiverID,
                  'total_credit':
                      (totalMin * int.parse(userData!.videoCallCoin.toString()))
                          .toString(),
                  'total_minutes': totalMin.toString(),
                  'unique_call': DateTime.now().toString(),
                  'type': '1'
                });
              }
            }
          })
        : null;
    log('Video Call Cutting');
    timer != null ? timer!.cancel() : null;
    player.stop();
    remoteUID = null;
    await engine.leaveChannel();
    await engine.release();
    ForegroundService().stop();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userData!.phoneNumber.toString())
        .update({
      'on_call': false,
    });
    super.onClose();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    playRing();
    FirebaseFirestore.instance.collection('user').doc(box.get('phone')).update({
      'on_call': true,
    });
    listner = FirebaseFirestore.instance
        .collection("call")
        .doc(channelName)
        .snapshots()
        .listen((value) {
      if (value.data() != null) {
        log('got call data--> ${value.data().toString()}');
        currCallStatus = value.data()!['call_status'];
        receiverID = value.data()!['calling_to_id'];
        if (currCallStatus == '3') {
          callEndFunction();
        }
        update();
      }
    });
    initForAgora();
    super.onInit();
  }

  Future<void> initForAgora() async {
    await [Permission.microphone, Permission.camera].request();
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: AppConst.agoraAppID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log("local user ${connection.localUid} joined");
          localUserJoined = true;
          update();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("remote user $remoteUid joined");
          player.stop();

          if (isBroadcast) {
            FirebaseFirestore.instance
                .collection("call")
                .doc(channelName)
                .update({'call_status': '0'});
            startCallTimer();
            isEverCallJoined = true;
            remoteUID = remoteUid;
            _.fbData.wallet = (int.parse(_.fbData.wallet.toString()) -
                    int.parse(userData!.videoCallCoin.toString()))
                .toString();
            log('curBal--> ${int.parse(_.fbData.wallet.toString()) - int.parse(userData!.videoCallCoin.toString())}');
            FirebaseFirestore.instance
                .collection('user')
                .doc(userData!.phoneNumber.toString())
                .update({
              'wallet': _.fbData.wallet,
            });
          } else {
            log('updating wallet');
            startCallTimer();
            isEverCallJoined = true;
            remoteUID = remoteUid;
            _.fbData.earnWallet = (int.parse(_.fbData.earnWallet.toString()) +
                    int.parse(userData!.videoCallCoin.toString()))
                .toString();
            _.update();
            FirebaseFirestore.instance
                .collection('user')
                .doc(userData!.phoneNumber.toString())
                .update({
              'earn_wallet': _.fbData.earnWallet,
            });
          }
          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          log("remote user $remoteUid left channel");
          callEndFunction();
          update();
        },
        onError: (err, msg) {
          log(msg.toString());
        },
      ),
    );
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();
    await engine.joinChannel(
      token: agoraToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    seconds %= 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  void startCallTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      ctime++;
      if (ctime >= 60 && isEverCallJoined) {
        totalMin++;
        ctime = 0;
        if (isBroadcast) {
          _.fbData.wallet = (int.parse(_.fbData.wallet.toString()) -
                  int.parse(userData!.videoCallCoin.toString()))
              .toString();
          log('curBal--> ${int.parse(_.fbData.wallet.toString()) - int.parse(userData!.videoCallCoin.toString())}');
          FirebaseFirestore.instance
              .collection('user')
              .doc(userData!.phoneNumber.toString())
              .update({
            'wallet': _.fbData.wallet,
          });

          if (int.parse(_.fbData.wallet.toString()) <
              int.parse(userData!.videoCallCoin.toString())) {
            EasyLoading.showError(
                'Don\'t Have Enought Balance to Continue Your Call Please Recharge Your Wallet Now And Try Again');
            callEndFunction();
          }
        } else {
          log('updateing Wallet');
          _.fbData.earnWallet = (int.parse(_.fbData.earnWallet.toString()) +
                  int.parse(userData!.videoCallCoin.toString()))
              .toString();
          _.update();
          FirebaseFirestore.instance
              .collection('user')
              .doc(userData!.phoneNumber.toString())
              .update({
            'earn_wallet': _.fbData.earnWallet,
          });
        }
      }
      callDuration = timer.tick;
      update();
    });
  }

  Future<void> callEndFunction() async {
    EasyLoading.dismiss();
    Get.offAll(() => Home());
    return await null;
  }

  @override
  void dispose() {
    engine.release();
    engine.leaveChannel();
    super.dispose();
  }

  int? remoteUID;
  late RtcEngine engine;
  bool localUserJoined = false;
  bool isMute = false;
  bool cameraToggle = false;
  Timer? timer;
  bool isEverCallJoined = false;
  int totalMin = 1;
  int callDuration = 0;
  int ctime = 0;
  String? receiverID;
  int? currEarnBal;
  String currCallStatus = '1';
  bool isBeuty = false;
}
