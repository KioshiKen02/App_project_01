import 'package:flutter/material.dart';
import 'package:project_01/pages/profile.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../screens/forget_password_screen.dart';
import '../theme/themeprovider.dart';
import 'help.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<SettingsPages> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String username = '';
  String email = '';
  bool _notificationsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await _dbHelper.getCurrentUser();
    if (user != null) {
      setState(() {
        username = user['username'];
        email = user['email'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor:Theme.of(context).colorScheme.primary,
            child: Text(username.isNotEmpty ? username[0].toUpperCase() : '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
            ),
          ),
          title: Text(username),
          subtitle: Text(email),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePages()),
            );
          },
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // Save notification preference to local storage or database
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Theme Mode'),
          trailing: Switch(
            value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              Provider.of<ThemeProvider>(context, listen: false).setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Support',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('About'),
                content: const Text('This is the about section.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () async {
            final confirmed = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              // Perform logout actions (e.g., clear user session)
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome',
                    (route) => false,
              );
            }
          },
        ),
      ],
    );
  }
}