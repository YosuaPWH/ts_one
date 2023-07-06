import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ts_one/presentation/routes.dart';

class NewAssessmentSuccess extends StatefulWidget {
  const NewAssessmentSuccess({super.key});

  @override
  State<NewAssessmentSuccess> createState() => _NewAssessmentSuccessState();
}

class _NewAssessmentSuccessState extends State<NewAssessmentSuccess> {

  @override
  void initState() {
    super.initState();
    return backToHome();
  }

  void backToHome() {
    var duration = const Duration(milliseconds: 1500);
    Timer(duration, () {
      Navigator.pushNamedAndRemoveUntil(context, NamedRoute.home, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/success.png'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Your assessment has already been recorded.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
