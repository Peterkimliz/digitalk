import 'package:digitalk/controller/auth_controller.dart';
import 'package:digitalk/widgets/custom_button.dart';
import 'package:digitalk/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text("Sign In"),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              CustomTextField(
                  controller: _authController.textEditingControllerEmail),
              SizedBox(
                height: 20,
              ),
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              CustomTextField(
                  controller: _authController.textEditingControllerPassword),
              SizedBox(
                height: 20,
              ),
              CustomButton(text: "Log In", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
