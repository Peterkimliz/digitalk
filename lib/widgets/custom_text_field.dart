import 'package:digitalk/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final type;

  CustomTextField({Key? key, required this.controller, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "$type is required";
        } else {
          return null;
        }
      },
      obscureText: type == "password" ? true : false,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: buttonColor, width: 2)),
          errorBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color:Colors.red, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: secondaryBackgroundColor, width: 1))),
    );
  }
}
