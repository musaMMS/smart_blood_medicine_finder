import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  String? selectedBloodGroup;
  String? requestId;

  Future<void> sendRequest() async {
    if (selectedBloodGroup == null || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final docRef = await FirebaseFirestore.instance.collection(
          'blood_requests').add({
        'bloodGroup': selectedBloodGroup,
        'location': locationController.text.trim(),
        'details': detailsController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid ?? 'guest_user',
      });

      setState(() {
        requestId = docRef.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Sent Successfully!')),
      );
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text('Request Blood'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Stack(
        children: [
          // Full screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/beautiful-heart-shape.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable foreground content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 60),
                // AppBar height + top space
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Blood Group'),
                          items: ['A+', 'B+', 'O+', 'AB+']
                              .map((group) =>
                              DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBloodGroup = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                              labelText: 'Location'),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: detailsController,
                          decoration: const InputDecoration(
                              labelText: 'More Details'),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: sendRequest,
                          child: const Text('SEND REQUEST'),
                        ),
                        const SizedBox(height: 30),
                        if (requestId != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Request ID: $requestId',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        TextButton(onPressed: (){},
                            
                            child: Text('Guest',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
