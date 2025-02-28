import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_01/screens/forget_password_screen.dart';
import 'package:project_01/screens/signup_screen.dart';
import 'package:project_01/theme/theme.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = false;

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
              padding: EdgeInsets.fromLTRB( 25.0, 50.0, 25.0, 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                        //welcome
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: lightColorScheme.primary,
                          ),
                          ),
                        SizedBox(
                          height: 50,
                        ),
                        //Email
                        TextFormField(
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            label: Text('Email'),
                            hintText: 'Please Enter Your Email',
                            hintStyle: TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black26
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black26
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Password
                        TextFormField(
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            label: Text('Password'),
                            hintText: 'Please Enter Your Password',
                            hintStyle: TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //remember me && forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                    onChanged: (bool? value){
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor: lightColorScheme.primary,
                                ),
                                Text(
                                  'Remember Me',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                             ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) =>  ForgetPasswordScreen(),
                                ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              if(_formSignInKey.currentState!.validate()
                              && rememberPassword){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Processing Data'),
                                  ),
                                );
                              } else if (!rememberPassword){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please Agree to the Terms and Conditions'),
                                  ),
                                );
                              }
                            },
                            child: Text('Sign In'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Sign In With
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black26,
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
                                  color: Colors.black26,
                                )
                              )
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Brand(Brands.facebook_f),
                            Brand(Brands.twitterx_2),
                            Brand(Brands.google),
                            Brand(Brands.github),
                            Brand(Brands.apple_logo),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //don't have account?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                   ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: lightColorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

