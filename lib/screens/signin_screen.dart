import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:project_01/config/api_config.dart';
import 'package:project_01/screens/forget_password_screen.dart';
import 'package:project_01/screens/signup_screen.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';
import 'package:provider/provider.dart';
import '../theme/themeprovider.dart';
import '../database/database_helper.dart';

class SignInScreen extends StatefulWidget {
  final bool isOfflineMode;

  const SignInScreen({
    super.key,
    this.isOfflineMode = false,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // Track loading state

  Future<void> _handleSignIn() async {
    if (_formSignInKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      await Future.delayed(const Duration(seconds: 10));

      if (widget.isOfflineMode) {
        await _handleOfflineLogin();
      } else {
        await _handleOnlineLogin();
      }
    }
  }

  Future<void> _handleOfflineLogin() async {
    if (await _dbHelper.verifyLocalCredentials(
        emailController.text, passwordController.text)) {
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Stop loading
      });

      // Show Flushbar for successful offline login
      await Flushbar(
        message: 'Server Unreachable: Switching to Offline Mode.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);

      // Navigate to the dashboard
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
            (route) => false,
      );
    } else {
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Stop loading
      });

      // Show Flushbar for invalid credentials
      await Flushbar(
        message: 'Invalid credentials',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  }

  Future<void> _handleOnlineLogin() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        body: json.encode({
          'email': emailController.text.toLowerCase(),
          'password': passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        await _dbHelper.clearUsers();
        await _dbHelper.saveUser({
          'username': data['user']['username'],
          'email': data['user']['email'],
          'password': passwordController.text,
        });

        if (rememberPassword) {
          await _dbHelper.saveUserCredentials(
              emailController.text, passwordController.text, null);
        }

        if (!mounted) return;

        setState(() {
          _isLoading = false; // Stop loading
        });

        // Success message
        await Flushbar(
          message: 'Successfully Logged In',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(10),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context);

        // Navigate to the dashboard
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
              (route) => false,
        );
      } else {
        if (!mounted) return;

        setState(() {
          _isLoading = false; // Stop loading
        });

        await Flushbar(
          message: data['message'] ?? 'Login failed',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(10),
          icon: const Icon(Icons.error, color: Colors.white),
        ).show(context);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Stop loading
      });

      await Flushbar(
        message: 'Network issue detected, switching to offline mode.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      ).show(context);

      await _handleOfflineLogin();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final savedCredentials = await _dbHelper.getSavedCredentials();
    if (savedCredentials != null) {
      setState(() {
        emailController.text = savedCredentials['email']!;
        passwordController.text = savedCredentials['password']!;
        rememberPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return CustomScaffoldWidget(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white, // Dynamic background
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black, // Dynamic text color
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildTextField(
                            controller: emailController,
                            label: 'Email',
                            icon: Icons.email,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 10),

                          _buildPasswordField(isDarkMode),
                          const SizedBox(height: 10),

                          _buildRememberMeAndForgotPassword(isDarkMode),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? Colors.white : Colors.black, // Dynamic button color
                                foregroundColor: Theme.of(context).colorScheme.secondary, // Dynamic text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildMargin(isDarkMode),
                          const SizedBox(height: 30),

                          _buildSocialLogin(isDarkMode),
                          const SizedBox(height: 30),

                          _buildSignUpOption(isDarkMode),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5), // Semi-transparent overlay
              child: Center(
                child: Lottie.asset(
                  'assets/Loading.json', // Path to your Lottie file
                  width: 80, // Adjust size as needed
                  height: 80,
                  fit: BoxFit.cover,
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
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.white30 : Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.white30 : Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isDarkMode) {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      obscureText: _obscurePassword,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: isDarkMode ? Colors.white : Colors.black),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        labelText: 'Password',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.white30 : Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberPassword,
              onChanged: (bool? value) {
                setState(() {
                  rememberPassword = value!;
                });
              },
              activeColor:Theme.of(context).colorScheme.primary,
              checkColor: Theme.of(context).colorScheme.secondary,
            ),
            Text(
              'Remember Me',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgetPasswordScreen(),
              ),
            );
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMargin(bool isDarkMode) {
    return Column(
      children: [
        // Sign In With
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white : Colors.black,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Sign In With',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDarkMode ? Colors.white : Colors.black,
                thickness: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLogin(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Brand(Brands.google, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
        Brand(Brands.facebook_f, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
        Brand(Brands.twitterx, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
        Brand(Brands.git, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
        Brand(Brands.apple_logo, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
      ],
    );
  }

  Widget _buildSignUpOption(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: Text(
            ' Sign Up',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}