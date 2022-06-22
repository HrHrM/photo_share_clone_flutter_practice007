// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinterest_clone_codingcafe/src/account_check/account_check.dart';
import 'package:pinterest_clone_codingcafe/widgets/button_login.dart';
import 'package:pinterest_clone_codingcafe/widgets/input_field.dart';

class Credentials extends StatelessWidget {
  Credentials({
    Key? key,
  }) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      // ignore: prefer_const_literals_to_create_immutables
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                'images/logo1.png',
              ),
              backgroundColor: Colors.orange.shade800,
            ),
          ),
          SizedBox(height: 15.0),
          InputField(
              hintText: 'Enter email',
              icon: Icons.email_rounded,
              obscureText: false,
              text: emailController),
          InputField(
              hintText: 'Enter password',
              icon: Icons.lock_rounded,
              obscureText: true,
              text: passwordController),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'forget_password'),
                child: Text(
                  'forgot password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          ButtonLogin(
            text: 'Login',
            press: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                  email: emailController.text.trim().toLowerCase(),
                  password: passwordController.text.trim(),
                );
                Navigator.pushReplacementNamed(context, 'home');
              } catch (e) {
                Fluttertoast.showToast(
                  msg: e.toString(),
                );
              }
            },
            color1: Colors.red,
            color2: Colors.redAccent,
          ),
          SizedBox(height: 15.0),
          AccountCheck(
              login: true,
              press: () {
                Navigator.pushNamed(context, 'sign_up');
              })
        ],
      ),
    );
  }
}
