// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:findovio_business/provider/buttons_state/wallet_buttons_months_provider.dart';
import 'package:findovio_business/provider/globals.dart';
import 'package:findovio_business/provider/salon_provider/create_salon_provider.dart';
import 'package:findovio_business/routes/app_pages.dart';
import 'package:findovio_business/utilities/authentication/findovio_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/salon_provider/get_salon_provider.dart';
import 'provider/salon_provider/get_salon_builder_provider.dart';
import 'screens/main_menu/main_menu.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var connectivityResult = await (Connectivity().checkConnectivity());
  bool isConnected = connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);

  // If connected, initialize Firebase
  if (isConnected) {
    await initializeFirebase();
  } else {
    const SnackBar snackBar = SnackBar(
        content: Text("Brak internetu. Sprawdź połączenie."),
        duration: Duration(seconds: 3));

    snackbarKey.currentState?.showSnackBar(snackBar);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar color
    statusBarIconBrightness: Brightness.dark, // Icons color
  ));
  // make flutter draw behind navigation bar
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => CreateSalonProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => GetSalonProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => GetSalonBuilderProvider(),
      ),
      ChangeNotifierProvider(
          create: (context) => WalletButtonsMonthsProvider()),
    ],
    child: const MyApp(),
  ));
  FlutterNativeSplash.remove();
}

final GlobalKey<MinimalExampleState> minimalExampleKey =
    GlobalKey<MinimalExampleState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // _requestPermission();
    _setupFirebaseMessagingHandlers();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            try {
              // snapshot.data?.reload();
            } catch (e) {
              const SnackBar snackBar = SnackBar(
                  content: Text("Brak internetu. Sprawdź połączenie."),
                  duration: Duration(seconds: 3));
              snackbarKey.currentState?.showSnackBar(snackBar);
            }
          }

          final bool isLoggedIn = snapshot.hasData;
          final initialRoute = isLoggedIn ? Routes.HOME : Routes.INTRO;
          // Get the user UID if available
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
            title: 'findovio biznes',
            scaffoldMessengerKey: snackbarKey,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              colorScheme: ColorScheme.fromSeed(
                  primary: const Color.fromARGB(255, 29, 29, 29),
                  seedColor: const Color.fromARGB(255, 255, 179, 65)),
              useMaterial3: true,
            ),
            initialRoute: initialRoute,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void _setupFirebaseMessagingHandlers() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    _handleMessage(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      _handleMessage(message);
    }
  });
}

void _handleMessage(RemoteMessage message) {
  // Implementuj logikę obsługi wiadomości otwartej z powiadomienia
  print('Handling message: ${message.messageId}');
}

AndroidNotificationChannel channelHigh = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'Ważne powiadomienia', // title
  description:
      'Te powiadomienia pokazują najważniejsze wydarzenia', //description
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('sound'),
  playSound: true,
);

AndroidNotificationChannel channelAd = const AndroidNotificationChannel(
  'high_importance_channel_ad', // id
  'Oferty', // title
  description: 'Wyświetlanie ofert', //description
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('sound'),
  playSound: true,
);

AndroidNotificationChannel channelLow = const AndroidNotificationChannel(
  'low_importance_channel', // id
  'Aktualizacje', // title
  description: 'Wyświetlanie ofert', //description
  importance: Importance.defaultImportance,
  playSound: false,
);

AndroidNotificationChannel defaultChannel = const AndroidNotificationChannel(
  'default_channel', // id
  'default Notifications', // title
  importance: Importance.none,
  playSound: false,
);
