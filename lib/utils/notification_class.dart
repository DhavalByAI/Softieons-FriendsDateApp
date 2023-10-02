import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_friends_date_app/call/audio_call_screen.dart';
import 'package:new_friends_date_app/call/video_call_screen.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/main.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log(receivedAction.body.toString());
    Map<String, String?> notificationData = receivedAction.payload ?? {};
    if (receivedAction.buttonKeyPressed == '1') {
      notificationData['call_type'] == '2'
          ? navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                      image: notificationData['caller_userImage']!,
                      name: notificationData[
                          'caller_username']!, //////hereeeeeeeeeeeeeeeeee
                      isBroadcast: false,
                      agoraToken: notificationData['agoraToken']!,
                      channelName: notificationData['channelName']!)),
              (Route<dynamic> route) => false)
          : navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => AudioCallScreen(
                      image: notificationData['caller_userImage']!,
                      name: notificationData[
                          'caller_username']!, //////hereeeeeeeeeeeeeeeeee
                      isBroadcast: false,
                      agoraToken: notificationData['agoraToken']!,
                      channelName: notificationData['channelName']!)),
              (Route<dynamic> route) => false);
    } else {
      log('Rejected Upcoming call From : ${notificationData['caller_username']}');
      FirebaseFirestore.instance
          .collection("call")
          .doc(notificationData['channelName'])
          .update({'totalDuration': '', 'call_status': '3'});
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false);
    }

    log('notificationLog --${receivedAction.toString()}');
  }
}
