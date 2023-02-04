import 'package:digitalk/screens/auth/login.dart';
import 'package:digitalk/screens/auth/register.dart';
import 'package:digitalk/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to \nDigiTalk",
                style: TextStyle(color: Colors.black, fontSize: 40),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(text: "Log In", onTap: () => Login()),
              SizedBox(
                height: 20,
              ),
              CustomButton(text: "Sign Up", onTap: () => Register())
            ],
          ),
        ),
      ),
    );
  }
}
