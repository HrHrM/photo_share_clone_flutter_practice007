// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pinterest_clone_codingcafe/widgets/text_field_container.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.obscureText,
      required this.text})
      : super(key: key);

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController text;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        cursorColor: Colors.white,
        obscureText: obscureText,
        controller: text,
        decoration: InputDecoration(
          hintText: hintText,
          helperStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          prefixIcon: Icon(icon, color: Colors.white, size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
