import 'dart:io';

import 'package:diamond_office/Diamond/employee/emp_home.dart';
import 'package:diamond_office/Diamond/emp_login.dart';
import 'package:diamond_office/Diamond/owner/owner_home.dart';
import 'package:diamond_office/Diamond/owner/owner_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'Diamond/LogIN/login_1.dart';
import 'Diamond/owner/real_time_database/real_time_database.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Bg messaged showed up : ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: TestWidget(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/launcher_icon')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        setState(() {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title.toString()),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body.toString())],
                    ),
                  ),
                );
              });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showNotification();
          },
          child: Text("Increment"),
        ),
      ),
    );
  }

  void showNotification() async {
    setState(() {
      count = count + 1;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Hello",
        "Testing Purpose value ${count}",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,

                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                sound: RawResourceAndroidNotificationSound('notification.mp3'),
                icon: '@mipmap/launcher_icon')));
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   late FirebaseMessaging messaging;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getMessageNotifications();
//
//     // Add observer to detect app state: inactive, paused, resumed
//     WidgetsBinding.instance?.addObserver(this);
//
//     messaging = FirebaseMessaging.instance;
//     messaging.getToken().then((value) {
//       print("fcmToken : - $value");
//       // SpManager.putString(fcmToken, value.toString());
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//
//   getMessageNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       handleNotificationClick(initialMessage, true);
//     }
//
//     if (Platform.isIOS) {
//       NotificationSettings settings = await FirebaseMessaging.instance
//           .requestPermission(
//               alert: true,
//               announcement: false,
//               badge: true,
//               carPlay: false,
//               criticalAlert: false,
//               sound: true,
//               provisional: false);
//       print("user granted permission : ${settings.authorizationStatus}");
//     }
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('mipmap/launcher_icon');
//
//     /// Note: permissions aren't requested here just to demonstrate that can be
//     /// done later
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false,
//             onDidReceiveLocalNotification: (
//               int id,
//               String? title,
//               String? body,
//               String? payload,
//             ) async {
//               print(title);
//             });
//     const MacOSInitializationSettings initializationSettingsMacOS =
//         MacOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );
//
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//       macOS: initializationSettingsMacOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       print("message received");
//       print(event.notification!.body);
//       RemoteNotification? notification = event.notification;
//       AndroidNotification? android = event.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               playSound: true,
//               channelDescription: channel.description,
//               icon: android.smallIcon,
//             ),
//           ),
//         );
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Message clicked!');
//       handleNotificationClick(message, false);
//     });
//   }
//
//   void handleNotificationClick(RemoteMessage initialMessage, bool bool) {
//     Get.to(LogIN1());
//   }
// }
//
// Future<void> _messageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('background message ${message.notification?.body}');
// }
