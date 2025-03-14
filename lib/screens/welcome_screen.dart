import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_01/config/api_config.dart';
import 'package:project_01/screens/signin_screen.dart';
import '../widgets/custom_scaffold_widget.dart';
import '../widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isOnline = true;
  Timer? _connectionTimer;

  @override
  void initState() {
    super.initState();
    checkConnection();
    // Check connection status every 5 seconds
    _connectionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      checkConnection();
    });
  }

  Future<void> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.health),
      ).timeout(const Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          isOnline = response.statusCode == 200;
        });
      }
    } catch (e) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          isOnline = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _connectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'PROJECT 01\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '\n続行するには資格情報を入力してください',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isOnline ? 'Server is Online' : 'Server is Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: WelcomeButton(
                  buttonText: 'Get Started',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(isOfflineMode: !isOnline),
                      ),
                    );
                  },
                  color: Colors.white, // White button
                  style: const TextStyle(
                    color: Colors.black, // Black text
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}