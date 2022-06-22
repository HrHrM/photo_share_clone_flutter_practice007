// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinterest_clone_codingcafe/src/account_check/account_check.dart';
import 'package:pinterest_clone_codingcafe/widgets/button_signup.dart';
import 'package:pinterest_clone_codingcafe/widgets/input_field.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                  HeadTextFP(),
                  CredentialsFP(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CredentialsFP extends StatelessWidget {
  CredentialsFP({
    Key? key,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController(text: '');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'images/forget.png',
              width: 300.0,
            ),
          ),
          SizedBox(height: 10.0),
          InputField(
            hintText: 'Enter Email',
            icon: Icons.email_rounded,
            obscureText: false,
            text: emailController,
          ),
          SizedBox(height: 10.0),
          ButtonSignUp(
            text: 'Send link',
            press: () async {
              try {
                await _auth.sendPasswordResetEmail(
                  email: emailController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      'Correo de recuperacion enviado',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              } on FirebaseAuthException catch (e) {
                Fluttertoast.showToast(msg: e.toString());
              }
              Navigator.pushReplacementNamed(context, 'login');
            },
            color1: Colors.red,
            color2: Colors.redAccent,
          ),
          AccountCheck(
            login: false,
            press: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
        ],
      ),
    );
  }
}

class HeadTextFP extends StatelessWidget {
  const HeadTextFP({
    Key? key,
  }) : super(key: key);

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
              "Recuperar contraseña",
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
