import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  const AccountCheck({Key? key, required this.login, required this.press})
      : super(key: key);

  final bool login;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? 'Dont have account?' : 'Already have an account?',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? 'Create Account' : 'Login',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
