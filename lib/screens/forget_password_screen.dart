import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';
import '../database/database_helper.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({
    super.key,
  });

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formforgetpassword = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool checkinfo = false;

  Future<void> _handlePasswordReset() async {
    if (_formforgetpassword.currentState!.validate() && checkinfo) {
      try {
        final response = await http.post(
          Uri.parse('http://172.16.42.112:8081/auth/reset-password'),
          body: json.encode({
            'username': usernameController.text,
            'email': emailController.text.toLowerCase(),
            'password': passwordController.text,
          }),
          headers: {'Content-Type': 'application/json'},
        );
        if (!mounted) return;

        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          // Update password in local SQLite
          await _dbHelper.updateUserPassword(
              emailController.text.toLowerCase(),
              passwordController.text
          );
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Updated Successfully')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset failed: Check connection')),
        );
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              )
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.black, // Black background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formforgetpassword,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Forget Password',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // User Name
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your User Name';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white), // White text
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_rounded, color: Colors.white),
                          label: Text('User Name', style: TextStyle(color: Colors.white70)),
                          hintText: 'Please Enter Your User Name',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Email
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          // Email format validation
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white), // White text
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          label: Text('Email', style: TextStyle(color: Colors.white70)),
                          hintText: 'Please Enter Your Email',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Password
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.white), // White text
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          label: Text('Password', style: TextStyle(color: Colors.white70)),
                          hintText: 'Please Enter Your Password',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.white), // White text
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          label: Text('Confirm Your Password', style: TextStyle(color: Colors.white70)),
                          hintText: 'Please Enter Your Password',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white30
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: checkinfo,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkinfo = value!;
                                  });
                                },
                                activeColor: Colors.white, // White checkbox
                                checkColor: Colors.black, // Black checkmark
                              ),
                              Text(
                                'Check If All The Information Is Correct',
                                style: TextStyle(
                                  color: Colors.white70, // Light white text
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Save New Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handlePasswordReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White button
                            foregroundColor: Colors.black, // Black text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Save New Password'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
}