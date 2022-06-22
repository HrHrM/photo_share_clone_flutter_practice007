// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  const HeadText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Center(
            child: Text(
              'PhotoSharing',
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Signatra",
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white30,
                fontWeight: FontWeight.bold,
                fontFamily: "Bebas",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
