import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black, // Customize as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1. Introduction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "By using this application, you agree to comply with and be bound by these Terms and Conditions. "
                    "If you do not agree with any part of these terms, you may not use the application.",
              ),
              const SizedBox(height: 16),

              const Text(
                "2. User Responsibilities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "- You must use the application in a lawful manner.\n"
                    "- You are responsible for keeping your login credentials secure.\n"
                    "- You must not misuse, exploit, or tamper with the application.",
              ),
              const SizedBox(height: 16),

              const Text(
                "3. Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your personal data is protected according to our Privacy Policy. "
                    "We do not share your information with third parties without your consent.",
              ),
              const SizedBox(height: 16),

              const Text(
                "4. Limitation of Liability",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We are not responsible for any loss or damage resulting from the use of this application. "
                    "Your use of the application is at your own risk.",
              ),
              const SizedBox(height: 16),

              const Text(
                "5. Changes to Terms",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "We reserve the right to modify these terms at any time. Continued use of the application "
                    "after changes implies acceptance of the new terms.",
              ),
              const SizedBox(height: 16),

              // Back Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "Accept & Go Back",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
