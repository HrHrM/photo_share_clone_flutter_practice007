// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pinterest_clone_codingcafe/src/login/components/info.dart';
import 'package:pinterest_clone_codingcafe/src/sign_up/componentes/heading_text_signup.dart';
import 'package:pinterest_clone_codingcafe/src/sign_up/componentes/info_signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.deepOrange.shade100],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                HeadTextSignUp(),
                CredentialsSignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
