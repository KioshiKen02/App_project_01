import 'package:flutter/material.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/screens/signup_screen.dart';
import 'package:project_01/theme/theme.dart';
import 'package:project_01/widgets/custom_scaffold_widget.dart';
import 'package:project_01/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget (
      child: Column(
        children: [
          Flexible(
            flex: 8,
              child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 0,
            ),
            child: Center(child: RichText(
                textAlign: TextAlign.center,
                  text: const TextSpan(
                    children:[
                      TextSpan(
                        //Welcome Back
                          text: 'おかえり\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 85,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                          //Enter your credentials to continue
                          text: '\n続行するには資格情報を入力してください',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          )
                      )
                    ],
                  ),
                )
              ),
            )
          ),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign In',
                        onTap: SignInScreen(),
                        color: Colors.transparent,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign Up',
                        onTap: SignUpScreen(),
                        color: Colors.white,
                        style: TextStyle(
                          color: lightColorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
