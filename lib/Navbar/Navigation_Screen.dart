import 'package:flutter/material.dart';
import 'package:smart_blood_medicine_finder/home/Medicine/Medicine_screen.dart';
import 'package:smart_blood_medicine_finder/home/screens/Home_Screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MedicineDetailsScreen(medicineName: '',),
    Center(child: Text('Donation History Screen')), // placeholder
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = [
    'Request Blood',
    'Find Medicine',
    'Donation History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Blood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
