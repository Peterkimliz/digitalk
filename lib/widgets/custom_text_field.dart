import 'package:digitalk/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  CustomTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: buttonColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryBackgroundColor, width: 1))),
    );
  }
}
