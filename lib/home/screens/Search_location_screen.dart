import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final TextEditingController locationController = TextEditingController();
  List<Map<String, dynamic>> matchedRequests = [];

  Future<void> searchByLocation() async {
    final locationInput = locationController.text.trim();

    if (locationInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a location')),
      );
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('blood_requests')
          .where('location', isEqualTo: locationInput)
          .get();

      setState(() {
        matchedRequests = querySnapshot.docs
            .map((doc) => {
          'id': doc.id,
          'bloodGroup': doc['bloodGroup'],
          'location': doc['location'],
          'details': doc['details'],
        })
            .toList();
      });

      if (matchedRequests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No request found for this location')),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Location')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchByLocation,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: matchedRequests.length,
                itemBuilder: (context, index) {
                  final request = matchedRequests[index];
                  return Card(
                    child: ListTile(
                      title: Text("Blood Group: ${request['bloodGroup']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Location: ${request['location']}"),
                          Text("Details: ${request['details']}"),
                          Text("Request ID: ${request['id']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
