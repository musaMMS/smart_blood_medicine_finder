import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation History')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: Icon(Icons.circle, size: 12),
            title: Text('Blood Request • A+'),
            subtitle: Text('Apr 20'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.circle, size: 12),
            title: Text('Medicine Request'),
            subtitle: Text('Mar 15'),
          ),
        ],
      ),
    );
  }
}
