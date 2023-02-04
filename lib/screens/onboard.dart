import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to \nDigiTalk",
              style: TextStyle(color: Colors.black, fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}
