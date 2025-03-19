import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:project_01/config/api_config.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/screens/terms_and_conditions.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';
import 'package:project_01/database/database_helper.dart';

class SignUpScreen extends StatefulWidget {
  final bool isOfflineMode;

  const SignUpScreen({
    super.key,
    this.isOfflineMode = false,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool agreeTerms = false;
  bool _obscurePassword = true;

  Future<void> _handleSignUp() async {
    if (_formSignupKey.currentState?.validate() == true && agreeTerms) {
      final userData = {
        'username': usernameController.text,
        'email': emailController.text.toLowerCase(),
        'password': passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(ApiConfig.register),
          body: json.encode(userData),
          headers: {'Content-Type': 'application/json'},
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Connection timed out');
          },
        );

        if (!mounted) return;

        if (response.statusCode == 201) {
          await _dbHelper.saveUser(userData);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful (Online)')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } else {
          throw Exception("API Error: ${response.body}");
        }
      } catch (e) {
        await _dbHelper.saveUser(userData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet: Registered locally, will sync later'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        }
      }
    } else if (!agreeTerms) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the Terms and Conditions')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.black, // Updated background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Changed to white for contrast
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildTextField(
                        controller: usernameController,
                        label: 'User Name',
                        icon: Icons.account_circle_rounded,
                      ),
                      const SizedBox(height: 10),

                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),

                      _buildPasswordField(),
                      const SizedBox(height: 10),

                      _buildTermsAndConditions(),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildMargin(),
                      const SizedBox(height: 30),

                      _buildSocialLogin(),
                      const SizedBox(height: 30),

                      _buildSignInOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: agreeTerms,
          onChanged: (bool? value) {
            setState(() {
              agreeTerms = value ?? false;
            });
          },
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
        const Text(
          'I agree to the ',
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsAndConditions()),
            );
          },
          child: const Text(
            'Terms & Conditions.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
  Widget _buildMargin() {
    return Column(
      children: [
        // Sign In With
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Sign In With',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        Brand(Brands.google,  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),

        Brand(Brands.facebook_f,  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),

        Brand(Brands.twitterx,  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),

        Brand(Brands.git,  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),

        Brand(Brands.apple_logo,  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),

      ],
    );
  }

  Widget _buildSignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            ),
            );
          },
          child: Text(
            ' Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
