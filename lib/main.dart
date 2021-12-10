import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications/notifications.dart';
import 'routes.dart';
import 'theme/theme.dart';

late FirebaseAuth auth;
late FirebaseFirestore firestore;
late FirebaseMessaging messaging;

late SharedPreferences preferences;

late FlutterLocalNotificationsPlugin flutterLocalNotifications;

// Create a notification channel for use in Foreground Notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'bookings', // id
  'Bookings', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

void main() async {
  // Ensure Flutter is initialized before going further
  WidgetsFlutterBinding.ensureInitialized();

  // Initialized the Firebase application
  await Firebase.initializeApp();

  // Lock the application orientation to Portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create a new instance of the Flutter Local Notifications, for use with Foreground Notifications
  flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  // Initialize the Flutter Local Notifications with an icon
  await flutterLocalNotifications.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));

  await flutterLocalNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // connect with firebase instance
  auth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;
  messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // when a notification received from firebase
  FirebaseMessaging.onMessage.listen(onMessage);

  // Get a new instance of Shared Preferences
  preferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      routes: Routes.routes,
      onGenerateRoute: Routes.onGenerateRoute,
      // If the user is logged in, we go to the Home Screen, otherwise, go to the Auth Screen
      initialRoute: auth.currentUser == null ? Routes.AUTH : Routes.HOME,
    );
  }
}
