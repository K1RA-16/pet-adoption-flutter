import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'homeView.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timer();
  }

  void timer() {
    Future.delayed(
        const Duration(seconds: 3),
        () async => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const RiveAnimation.asset(
                'assets/perrito.riv',
                fit: BoxFit.cover,
              ))),
    );
  }
}
