import 'package:flutter/material.dart';


class WelcomeButton extends StatelessWidget {
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final TextStyle? style;

  const WelcomeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => onTap!,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
          child: Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: style!,
          )
      ),
    );
  }
}
