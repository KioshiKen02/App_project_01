import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/screens/terms_and_conditions.dart';
import 'package:project_01/theme/theme.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreeTerms = false;
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
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //welcome
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //Name
                      TextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Enter Your User Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_rounded),
                          label: Text('User Name'),
                          hintText: 'Please Enter Your User Name',
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
                      //Email
                      TextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Enter Your Email';
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
                            return 'Please Enter Your Password';
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
                      //Terms and Condition checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: agreeTerms,
                                onChanged: (bool? value){
                                  setState(() {
                                    agreeTerms = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              Text(
                                'I agree to the ',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => TermsAndConditions(),
                                  ),
                                  );
                                },
                                child: Text(
                                  'Terms & Condition.',
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
                      SizedBox(
                        height: 20,
                      ),
                      //Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formSignupKey.currentState!.validate()
                                && agreeTerms){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                            } else if (!agreeTerms){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please Agree to the Terms and Conditions'),
                                ),
                              );
                            }
                          },
                          child: Text('Sign Up'),
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
                                  'Sign Up With',
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
                            'Already have an account?',
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
                                builder: (context) => SignInScreen(),
                              ),
                              );
                            },
                            child: Text(
                              'Sign In',
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
