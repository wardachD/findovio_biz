import 'package:findovio_business/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print(
      '[Initialize firebase | Token ] User granted permission: ${settings.authorizationStatus}');
  final FCMToken = await messaging.getToken();
  print('[Initialize firebase | Token ] User token: $FCMToken');
}
