import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project_01/pages/calendar.dart';
import 'package:project_01/pages/note.dart';
import 'package:project_01/pages/settings.dart';
import 'package:provider/provider.dart';
import '../theme/themeprovider.dart';

class DashboardPages extends StatefulWidget {
  const DashboardPages({super.key});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'List',
    'Notes',
    'Calendar',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final List<Widget> pages = [
      const Center(child: Text('Home')),
      const Center(child: Text('list')),
      const NotePages(),
      const CalendarPages(),
      const SettingsPages(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.black, // Dynamic AppBar color
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(
            color: Colors.white, // Keep text color consistent
          ),
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        color: isDarkMode ? Colors.grey[800]! : Colors.black,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: isDarkMode ? Colors.grey[700] : Colors.black, // Dynamic button color
        animationDuration: const Duration(milliseconds: 300),
        onTap: _onItemTapped,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.people_rounded, size: 30, color: Colors.white),
          Icon(Icons.event_note_outlined, size: 30, color: Colors.white),
          Icon(Icons.calendar_month, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}