import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_blood_medicine_finder/widget/Color.dart';
import 'Navbar/Navigation_Screen.dart';
import 'Phone_auth/Phone_auth.dart';
import 'home/screens/Home_Screen.dart';
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
      // ✅ For dynamic phone argument routing
      onGenerateRoute: (settings) {
        if (settings.name == '/phone') {
          final phone = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PhoneAuthScreen(phone: phone),
          );
        }
        return null;
      },
        theme: appTheme,
    );
  }
}
