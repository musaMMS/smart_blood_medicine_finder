import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marquee/marquee.dart'; // <-- Marquee package import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> countryCodes = ['+880', '+91', '+1', '+44', '+61'];

  String? selectedCountryCode;
  String? selectedBloodGroup;

  void registerUser() async {
    if (!registerFormKey.currentState!.validate()) return;

    String name = nameController.text.trim();
    String phone = selectedCountryCode! + phoneController.text.trim();
    String city = cityController.text.trim();
    String bloodGroup = selectedBloodGroup ?? '';

    try {
      Navigator.pushNamed(context, '/phone', arguments: phone);

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'city': city,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Registration successful!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Registration failed: $e")),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes')),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
          children: [
            // 🔴 Marquee Line
            Container(
              color: Colors.redAccent,
              height: 30,
              width: double.infinity,
              child:  Marquee(
                text: '🩸 এখনই রেজিস্টার করুন এবং জীবন বাঁচান! আপনার রক্তদান গুরুত্বপূর্ণ ❤️   ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                velocity: 40.0,
                blankSpace: 50.0,
              ),
            ),
            // 🔽 Registration Form with background image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/anastasiia-ornarin-2ldM4DsMm6M-unsplash.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Form(
                    key: registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                value: selectedCountryCode,
                                decoration: const InputDecoration(labelText: 'Code'),
                                items: countryCodes.map((code) {
                                  return DropdownMenuItem(value: code, child: Text(code));
                                }).toList(),
                                onChanged: (value) => setState(() => selectedCountryCode = value),
                                validator: (value) => value == null ? 'Select country code' : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(labelText: 'Phone Number'),
                                validator: (value) => value == null || value.isEmpty ? 'Enter your phone number' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: (value) => value == null || value.isEmpty ? 'Enter your city' : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedBloodGroup,
                          decoration: const InputDecoration(labelText: 'Blood Group'),
                          items: bloodGroups.map((bg) {
                            return DropdownMenuItem(value: bg, child: Text(bg));
                          }).toList(),
                          onChanged: (newGroup) => setState(() => selectedBloodGroup = newGroup),
                          validator: (value) => value == null ? 'Select a blood group' : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
