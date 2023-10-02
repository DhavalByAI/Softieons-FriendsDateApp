import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_friends_date_app/splash_screen/logo.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/change_status.dart';
import 'package:new_friends_date_app/utils/notification_class.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'app_methods.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<void> showCallkitIncoming(String uuid, Map<String, dynamic> data) async {
  final params = CallKitParams(
    id: uuid,
    nameCaller: data['caller_username'],
    appName: 'Soft Love',
    avatar: data['caller_userImage'],
    handle: data['title'],
    type: data['call_type'] == '2' ? 1 : 0,
    duration: 300000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      // callbackText: 'Call back',
    ),
    extra: data,
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/icons/hlo_logo.png',
      actionColor: '#4CAF50',
    ),
  );

  await FlutterCallkitIncoming.showCallkitIncoming(
    params,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // String? title = message.notification?.title;
  // WidgetsFlutterBinding.ensureInitialized();

  // FlutterCallkitIncoming.onEvent.listen((event) {
  //   switch (event!.event) {
  //     case Event.actionCallIncoming:
  //       break;
  //     case Event.actionCallStart:
  //       break;
  //     case Event.actionCallAccept:
  //       print(event.body.toString());

  //       event.body['extra']['call_type'] == '2'
  //           ? navigatorKey.currentState?.pushAndRemoveUntil(
  //               MaterialPageRoute(
  //                   builder: (context) => VideoCallScreen(
  //                       image: event.body['extra']['caller_userImage']!,
  //                       name: event.body['extra']
  //                           ['caller_username']!, //////hereeeeeeeeeeeeeeeeee
  //                       isBroadcast: false,
  //                       agoraToken: event.body['extra']['agoraToken']!,
  //                       channelName: event.body['extra']['channelName']!)),
  //               (Route<dynamic> route) => false)
  //           : navigatorKey.currentState?.pushAndRemoveUntil(
  //               MaterialPageRoute(
  //                   builder: (context) => AudioCallScreen(
  //                       image: event.body['extra']['caller_userImage'],
  //                       name: event.body['extra']
  //                           ['caller_username']!, //////hereeeeeeeeeeeeeeeeee
  //                       isBroadcast: false,
  //                       agoraToken: event.body['extra']['agoraToken'],
  //                       channelName: event.body['extra']['channelName'])),
  //               (Route<dynamic> route) => false);

  //       break;
  //     case Event.actionCallDecline:
  //       FirebaseFirestore.instance
  //           .collection("call")
  //           .doc(event.body['extra']['channelName'])
  //           .update({'totalDuration': '', 'call_status': '3'});
  //       navigatorKey.currentState?.pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => Home()),
  //           (Route<dynamic> route) => false);
  //       break;
  //     case Event.actionCallEnded:
  //       FirebaseFirestore.instance
  //           .collection("call")
  //           .doc(event.body['extra']['channelName'])
  //           .update({'totalDuration': '', 'call_status': '3'});
  //       navigatorKey.currentState?.pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => Home()),
  //           (Route<dynamic> route) => false);
  //       break;
  //     case Event.actionCallTimeout:
  //       FirebaseFirestore.instance
  //           .collection("call")
  //           .doc(event.body['extra']['channelName'])
  //           .update({'totalDuration': '', 'call_status': '3'});
  //       navigatorKey.currentState?.pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => Home()),
  //           (Route<dynamic> route) => false);
  //       break;
  //     case Event.actionCallCallback:
  //       // TODO: only Android - click action `Call back` from missed call notification
  //       break;
  //     case Event.actionCallToggleHold:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionCallToggleMute:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionCallToggleDmtf:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionCallToggleGroup:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionCallToggleAudioSession:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionDidUpdateDevicePushTokenVoip:
  //       // TODO: only iOS
  //       break;
  //     case Event.actionCallCustom:
  //       // TODO: for custom action
  //       break;
  //   }
  // });
  String? body = message.data.toString();
  var map = <String, String>{};
  message.data.forEach((key, value) {
    map.addAll({key: value.toString()});
  });
  print('msgData --> ${message.data}');

  // AndroidForegroundService.startAndroidForegroundService(
  //     foregroundStartMode: ForegroundStartMode.stick,
  //     foregroundServiceType: ForegroundServiceType.phoneCall,
  //     content: message.data.toString() != '{}'
  //         ? NotificationContent(
  //             id: 123,
  //             displayOnForeground: true,
  //             channelKey: 'call_channel',
  //             title: map['title'],
  //             body: map['body'],
  //             displayOnBackground: true,
  //             payload: map,
  //             category: NotificationCategory.Call,
  //             fullScreenIntent: true,
  //             wakeUpScreen: true,
  //             autoDismissible: false,
  //             // customSound: 'assets/ringtone/ring.wav',
  //             backgroundColor: Colors.orange,
  //           )
  //         : NotificationContent(
  //             id: 321,
  //             displayOnForeground: true,
  //             channelKey: 'msg_channel',
  //             title: '${map['title']} Messaged You',
  //             body: body,
  //             displayOnBackground: true,
  //             category: NotificationCategory.Message,
  //             fullScreenIntent: false,
  //             wakeUpScreen: true,
  //             autoDismissible: false,
  //             backgroundColor: Colors.orange,
  //             actionType: ActionType.KeepOnTop,
  //             locked: true,
  //           ),
  //     actionButtons: message.data.toString() != '{}'
  //         ? [
  //             NotificationActionButton(
  //               key: '1',
  //               label: 'Accept Call',
  //               color: Colors.green,
  //               autoDismissible: true,
  //             ),
  //             NotificationActionButton(
  //                 key: '0',
  //                 label: 'Reject Call',
  //                 color: Colors.red,
  //                 autoDismissible: true),
  //           ]
  //         : null);

  // // showCallkitIncoming(const Uuid().v4(), map);

  message.data.toString() != '{}'
      ? AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 123,
            displayOnForeground: true,
            channelKey: 'call_channel',
            title: map['title'],
            body: map['body'],
            displayOnBackground: true,
            payload: map,
            category: NotificationCategory.Call,
            fullScreenIntent: true,
            wakeUpScreen: true,
            autoDismissible: false,
            // customSound: 'assets/ringtone/ring.wav',
            backgroundColor: Colors.orange,
          ),
          actionButtons: [
              NotificationActionButton(
                key: '1',
                label: 'Accept Call',
                color: Colors.green,
                autoDismissible: true,
              ),
              NotificationActionButton(
                  key: '0',
                  label: 'Reject Call',
                  color: Colors.red,
                  autoDismissible: true),
            ])
      : AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 321,
            displayOnForeground: true,
            channelKey: 'msg_channel',
            title: '${map['title']} Messaged You',
            body: body,
            displayOnBackground: true,
            category: NotificationCategory.Message,
            fullScreenIntent: false,
            wakeUpScreen: true,
            autoDismissible: false,
            backgroundColor: Colors.orange,
            actionType: ActionType.KeepOnTop,
            locked: true,
          ),
        );

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

@pragma('vm:entry-point')
void fromNative() {
  print('Call From Native');
  WidgetsFlutterBinding.ensureInitialized();
  AppMethod.platform.setMethodCallHandler(
    (call) async {
      print(call.method);
      var method = call.method;
      if (method.trim() == "bgMethod") {
        WidgetsFlutterBinding.ensureInitialized();
        log('[BackgroundFetch]Running Background Task');
        await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyCZYECziY5TwYTlQmb_Uu8CdubtOXO-3Ho",
                appId: "1:579419343103:android:237da76590dec22deb24ca",
                messagingSenderId: "579419343103",
                projectId: "friends-date-app-new"));
        final appDocumentDirectory = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDirectory.path);
        await Hive.openBox('myBox');
        var bgbox = Hive.box('myBox');
        changeStatus(0, backgroundPhone: bgbox.get('phone'));
      }
      return true;
    },
  );
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  print('taskId-->$taskId');
  bool isTimeout = task.timeout;
  if (taskId == 'com.task.offline') {
    WidgetsFlutterBinding.ensureInitialized();
    log('[BackgroundFetch]Running Background Task');
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCZYECziY5TwYTlQmb_Uu8CdubtOXO-3Ho",
            appId: "1:579419343103:android:237da76590dec22deb24ca",
            messagingSenderId: "579419343103",
            projectId: "friends-date-app-new"));
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox('myBox');
    var bgbox = Hive.box('myBox');
    changeStatus(0, backgroundPhone: bgbox.get('phone')).then((value) {
      BackgroundFetch.finish(taskId);
    });
  }
  if (isTimeout) {
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }

  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  secureScreen();

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox('myBox');
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'call_channel',
      channelName: 'Call Channel',
      channelDescription: 'Channel Of Calling',
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
      enableVibration: true,
      playSound: true,
      onlyAlertOnce: false,
    )
  ]);

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) async {
      NotificationController.onActionReceivedMethod(receivedAction);
    },
    onNotificationCreatedMethod:
        (ReceivedNotification receivedNotification) async {
      NotificationController.onNotificationCreatedMethod(receivedNotification);
    },
    onNotificationDisplayedMethod:
        (ReceivedNotification receivedNotification) async {
      NotificationController.onNotificationDisplayedMethod(
          receivedNotification);
    },
    onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
      NotificationController.onDismissActionReceivedMethod(receivedAction);
    },
  );

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCZYECziY5TwYTlQmb_Uu8CdubtOXO-3Ho",
          appId: "1:579419343103:android:237da76590dec22deb24ca",
          messagingSenderId: "579419343103",
          projectId: "friends-date-app-new"));

  initfirebase();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(const MyApp());
}

Future initfirebase() async {
  FirebaseMessaging.onMessage.listen((message) async {
    String? title = message.notification?.title;
    String? body = message.data.toString();

    var map = <String, String>{};
    message.data.forEach((key, value) {
      map.addAll({key: value.toString()});
    });
    // showCallkitIncoming(const Uuid().v4(), map);
    log('msgData --> ${message.data}');
    message.data.toString() != '{}'
        ? AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 123,
              displayOnForeground: true,
              channelKey: 'call_channel',
              title: map['title'],
              body: map['body'],
              displayOnBackground: true,
              payload: map,
              category: NotificationCategory.Call,
              fullScreenIntent: true,
              wakeUpScreen: true,
              autoDismissible: false,
              actionType: ActionType.KeepOnTop,
              locked: true,

              // customSound: 'assets/ringtone/ring.wav',
              backgroundColor: Colors.orange,
            ),
            actionButtons: [
                NotificationActionButton(
                  key: '1',
                  label: 'Accept Call',
                  color: Colors.green,
                  autoDismissible: true,
                ),
                NotificationActionButton(
                    key: '0',
                    label: 'Reject Call',
                    color: Colors.red,
                    autoDismissible: true),
              ])
        : AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 321,
              displayOnForeground: true,
              channelKey: 'msg_channel',
              title: '$title Messaged You',
              body: body,
              displayOnBackground: true,
              category: NotificationCategory.Message,
              fullScreenIntent: false,
              wakeUpScreen: true,
              autoDismissible: false,
              backgroundColor: Colors.orange,
            ),
          );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initPlatformState().then((value) {
      BackgroundFetch.scheduleTask(
        TaskConfig(
            taskId: "com.task.offline",
            delay: 1000,
            periodic: true,
            enableHeadless: true,
            stopOnTerminate: false,
            startOnBoot: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            forceAlarmManager: true,
            requiredNetworkType: NetworkType.NONE),
      ).then((value) {
        BackgroundFetch.start().then((int status) {
          print('[BackgroundFetch] start success: $status');
        }).catchError((e) {
          print('[BackgroundFetch] start FAILURE: $e');
        });
      });
    });

    super.initState();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 1,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            startOnBoot: true,
            forceAlarmManager: true,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      // BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {});

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Friends Date',
      theme: ThemeData(
          primaryColor: AppColors.mainColor,
          primarySwatch: Colors.purple,
          fontFamily: GoogleFonts.poppins().fontFamily,
          canvasColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const Logo(),
      builder: EasyLoading.init(),
      navigatorKey: navigatorKey,
    );
  }
}
