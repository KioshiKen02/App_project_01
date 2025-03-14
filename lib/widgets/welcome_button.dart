import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final Color color;
  final TextStyle style;

  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.color,
    required this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
