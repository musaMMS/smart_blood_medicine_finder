import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();
  String? selectedBloodGroup;
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  void searchUsers() async {
    final String city = cityController.text.trim();
    final String? bloodGroup = selectedBloodGroup;

    if (city.isEmpty || bloodGroup == null || bloodGroup.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Please enter both city and blood group')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      searchResults = [];
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('city', isEqualTo: city)
          .where('bloodGroup', isEqualTo: bloodGroup)
          .get();

      final results = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        searchResults = results;
      });

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No donors found in "$city" with blood group "$bloodGroup"')),
        );
      }
    } catch (e) {
      debugPrint('❌ Error searching users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Enter city',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedBloodGroup,
                  decoration: const InputDecoration(labelText: 'Select Blood Group'),
                  items: bloodGroups.map((String bg) {
                    return DropdownMenuItem(value: bg, child: Text(bg));
                  }).toList(),
                  onChanged: (String? newGroup) {
                    setState(() {
                      selectedBloodGroup = newGroup;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: searchUsers,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: searchResults.isEmpty
                      ? const Center(child: Text('🔍 Search results will appear here.'))
                      : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var user = searchResults[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(user['name'] ?? 'No name'),
                          subtitle: Text(
                            '📍 ${user['city'] ?? ''} | 🩸 ${user['bloodGroup'] ?? ''}',
                          ),
                          trailing: Text('📞 ${user['phone'] ?? ''}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Searching...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
