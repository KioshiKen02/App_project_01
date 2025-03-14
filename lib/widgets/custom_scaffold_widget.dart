import 'package:flutter/material.dart';

class CustomScaffoldWidget extends StatelessWidget {
  final Widget? child;
  const CustomScaffoldWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black, // Changed to solid black
        elevation: 0,
      ),
      extendBodyBehindAppBar: false, // No need to extend body behind AppBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey], // Black & White gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: child ?? const SizedBox(), // Ensure child is not null
        ),
      ),
    );
  }
}
