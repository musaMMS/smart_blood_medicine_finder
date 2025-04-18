import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  void loginUser() async {
    if (!loginFormKey.currentState!.validate()) return;

    String phone = phoneController.text.trim();

    try {
      // Check if user exists in Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ User not found. Please register first.")),
        );
      } else {
        // If user is found, navigate to HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Login successful!")),
        );

        // Navigate to Home Screen
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Login failed: $e")),
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Navigate back to RegisterScreen
    Navigator.pushReplacementNamed(context, '/register');
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: loginFormKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your phone number'
                      : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginUser,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
