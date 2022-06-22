// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.redAccent, Colors.red],
        ),
        borderRadius: BorderRadius.circular(12),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          BoxShadow(
            offset: Offset(-2, -2),
            spreadRadius: 1,
            blurRadius: 4,
            color: Colors.red,
          ),
          BoxShadow(
            offset: Offset(-2, -2),
            spreadRadius: 1,
            blurRadius: 4,
            color: Colors.red,
          ),
        ],
      ),
      child: child,
    );
  }
}
