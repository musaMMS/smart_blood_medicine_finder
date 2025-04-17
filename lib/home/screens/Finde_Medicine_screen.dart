import 'package:flutter/material.dart';

class FindMedicineScreen extends StatelessWidget {
  const FindMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Medicine')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Medicine Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Medicine'),
              subtitle: const Text('Location'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Medicine'),
              subtitle: const Text('Location'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
