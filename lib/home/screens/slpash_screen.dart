import 'package:flutter/material.dart';
import 'package:smart_blood_medicine_finder/Navbar/Navigation_Screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
                color: Colors.grey[300], // Placeholder for image
                child: const Icon(Icons.bloodtype, size: 60),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to next screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen()));
                },
                child: const Text('GET STARTED'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
