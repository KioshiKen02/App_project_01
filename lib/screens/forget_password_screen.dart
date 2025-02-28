import 'package:flutter/material.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';
import '../theme/theme.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({
    super.key,
  });

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formforgetpassword = GlobalKey<FormState>();
  bool checkinfo = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
              padding: EdgeInsets.fromLTRB( 25.0, 40.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                      //welcome
                      Text(
                        'Forget Password',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //user Name
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
                        controller: passwordController,
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
                      //Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Enter Your Password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          label: Text('Confirm Your Password'),
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
                      //Note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value:checkinfo,
                                onChanged: (bool? value){
                                  setState(() {
                                    checkinfo = value!;
                                  });
                                },
                                activeColor: lightColorScheme.error,
                              ),
                              Text(
                                'Check If All The Information Is Correct',
                                style: TextStyle(
                                  color: Colors.red,
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
                      //Save New Password
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formforgetpassword.currentState!.validate()){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Password Updated Successfully'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop( context, MaterialPageRoute(builder: (BuildContext context) {
                                return SignInScreen();
                              }));
                            }
                          },
                          child: Text('Save New Password'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //don't have account?
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
