import 'package:flutter/material.dart';

class CustomScaffoldWidget extends StatelessWidget {
  final Widget? child;
  const CustomScaffoldWidget({super.key , this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
              child: child!,
          )
        ],
      ),
    );
  }
}
