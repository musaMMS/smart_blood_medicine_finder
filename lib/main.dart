import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_blood_medicine_finder/widget/Color.dart';
import 'Navbar/Navigation_Screen.dart';
import 'Phone_auth/Phone_auth.dart';
import 'home/screens/Login_screen.dart';
import 'home/screens/Registe_screen.dart';
import 'home/screens/slpash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAo2yuusux00km8rt2WhqVOK20Gj36j3LU',
      appId: '1:906112039266:android:20d3f37f534e3f1d2b143b',
      messagingSenderId: '906112039266',
      projectId: 'smart-blood-9e24d',
    ),
  );

  // FirebaseMessaging instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Requesting permission for iOS notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Checking the permission status
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications');
  } else {
    print('User declined or has not yet granted permission');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Blood & Medicine Finder',
      initialRoute: '/',
      routes: {
        '/s': (context) => SplashScreen(),
        '/': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => NavigationScreen(),
      },
      theme: appTheme,
    );
  }
}
