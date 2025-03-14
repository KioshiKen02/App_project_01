import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_01/config/api_config.dart';
import '../database/database_helper.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => ProfilePagesState();
}

class ProfilePagesState extends State<ProfilePages> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = await _dbHelper.getCurrentUser();
    if (user != null) {
      setState(() {
        usernameController.text = user['username'];
        emailController.text = user['email'];
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUser = await _dbHelper.getCurrentUser();
        final response = await http.post(
          Uri.parse(ApiConfig.updateProfile),
          body: json.encode({
            'user_id': currentUser?['id'],
            'email': emailController.text,
            'username': usernameController.text,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          await _dbHelper.updateUserProfile(
            emailController.text,
            usernameController.text,
          );
          if (!mounted) return;
          setState(() => isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        } else {
          throw Exception(data['message']);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 50,
                child: Text(
                  usernameController.text.isNotEmpty ?
                  usernameController.text[0].toUpperCase() : '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                      fontSize: 32,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Username cannot be empty' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Email cannot be empty' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
