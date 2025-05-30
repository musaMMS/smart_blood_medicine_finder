import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Phone_auth/viewcooection_screen.dart';
import '../donation/AddDonation_Screen.dart';
import '../donation/Donar_history_view.dart';
import 'ViewRequestScreen.dart';

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
  String? userName;

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

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
  }

  // 1. User Search Function
  void searchUsers() async {
    final String city = cityController.text.trim();
    final String? bloodGroup = selectedBloodGroup;

    if (city.isEmpty || bloodGroup == null || bloodGroup.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('❗ Please enter both city and blood group')),
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
          SnackBar(content: Text(
              'No donors found in "$city" with blood group "$bloodGroup"')),
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

  // 2. Send Connection Request Function
  void sendConnectionRequest(Map<String, dynamic> user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? senderPhone = prefs.getString('userPhone');
      String? senderName = prefs.getString('userName');
      String? senderBloodGroup = prefs.getString('bloodGroup');

      if (senderPhone == null || senderName == null || senderBloodGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❗ Sender info missing.")),
        );
        return;
      }

      // 1. Firestore এ Request সংরক্ষণ
      await FirebaseFirestore.instance.collection('connections').add({
        'senderName': senderName,
        'senderPhone': senderPhone,
        'senderBloodGroup': senderBloodGroup,
        'receiverPhone': user['phone'],
        'timestamp': Timestamp.now(),
      });

      // 2. Notification পাঠানো (FCM)
      if (user['fcmToken'] != null) {
        await sendPushNotification(
          token: user['fcmToken'],
          title: '🩸 Blood Connect Request',
          body: '$senderName sent you a blood donation request.',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Request sent successfully!')),
      );
    } catch (e) {
      debugPrint('❌ Error sending connection request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to send request.')),
      );
    }
  }

  // 3. Push Notification Function
  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'token': token,
        'title': title,
        'body': body,
        'timestamp': Timestamp.now(),
      });
      // তোমার Node.js server বা Firebase Functions ব্যবহার করে FCM পাঠাতে হবে
    } catch (e) {
      debugPrint('❌ Error sending FCM: $e');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userName != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: Card(
                          color: Colors.red[50],
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.redAccent),
                            title: Text(
                              '👋 Hello, $userName!',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              'Welcome to the app!',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewConnectionsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_active_rounded),
                      ),
                    ],
                  ),

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
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () {
                              sendConnectionRequest(user);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDonationScreen(donorId: ''),
                          ),
                        );
                      },
                      child: const Text('Add Donation'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonorHistoryScreen(donorId: ''),
                          ),
                        );
                      },
                      child: const Text('View History'),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_alert),
                      label: Text("Request Blood"),
                      onPressed: () => const AddDonationScreen(donorId: '',),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewRequestsScreen()),
                        );
                      },
                      child: Text("📢 View Requests"),
                    ),
                  ],
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

  void getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('📲 Device Token: $token');
  }
}
