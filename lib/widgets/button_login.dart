// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin(
      {Key? key,
      required this.text,
      required this.press,
      required this.color1,
      required this.color2})
      : super(key: key);

  final String text;
  final VoidCallback press;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 3),
                spreadRadius: 1,
                blurRadius: 4,
                color: Colors.red,
              ),
              BoxShadow(
                offset: Offset(-5, -5),
                spreadRadius: 1,
                blurRadius: 4,
                color: Colors.red,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
