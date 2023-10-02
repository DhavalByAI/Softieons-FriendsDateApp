import 'package:flutter/services.dart';

class AppMethod {
  static const platform =
      MethodChannel('com.example.new_friends_date_app/helper');
  var response;

  Future<void> UserOfflineMethod() async {}
  // Future<void> checkPermission() async {
  //   try {
  //     var result = await platform.invokeMethod('checkPermission');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  // }

  // Future<void> checkOverlayPermission() async {
  //   try {
  //     var result = await platform.invokeMethod('checkOverlayPermission');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  // }

  // void stopCallService() async {
  //   try {
  //     var result = await platform.invokeMethod('service');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  // }

  // Future<void> startIncomingService() async {
  //   try {
  //     var result = await platform.invokeMethod('startPopUp');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  // }
}
