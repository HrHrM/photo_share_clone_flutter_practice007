// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pinterest_clone_codingcafe/src/forget_password/forget_password_page.dart';
import 'package:pinterest_clone_codingcafe/src/home/home_page.dart';
import 'package:pinterest_clone_codingcafe/src/login/login_page.dart';
import 'package:pinterest_clone_codingcafe/src/owner_details/owner_datails.dart';
import 'package:pinterest_clone_codingcafe/src/sign_up/sign_up_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('firebase iniciado');
  runApp(const MyApp());
  print('app iniciada');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhotoShare Clone',
      home:
          FirebaseAuth.instance.currentUser == null ? LoginPage() : HomePage(),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'forget_password': (BuildContext context) => ForgetPasswordPage(),
        'sign_up': (BuildContext context) => SignUpPage(),
        'owner_details': (BuildContext context) => OwnerDetails(),
      },
    );
  }
}
