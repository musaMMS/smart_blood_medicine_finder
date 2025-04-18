import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // After splash, navigate to RegisterScreen or HomeScreen
      Navigator.pushReplacementNamed(context, '/reg');  // Or use '/home' if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SMART BLOOD & MEDICINE FINDER',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                height: 150,
                width: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.bloodtype, size: 60),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}