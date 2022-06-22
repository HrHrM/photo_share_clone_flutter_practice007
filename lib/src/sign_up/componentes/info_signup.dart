// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinterest_clone_codingcafe/src/account_check/account_check.dart';
import 'package:pinterest_clone_codingcafe/widgets/button_signup.dart';
import 'package:pinterest_clone_codingcafe/widgets/input_field.dart';

class CredentialsSignUp extends StatefulWidget {
  const CredentialsSignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<CredentialsSignUp> createState() => _CredentialsSignUpState();
}

class _CredentialsSignUpState extends State<CredentialsSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController(text: '');

  final TextEditingController passwordController =
      TextEditingController(text: '');

  final TextEditingController nameController = TextEditingController(text: '');

  final TextEditingController phoneController = TextEditingController(text: '');

  File? imageFile;
  String? imageUrl;

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.camera, color: Colors.red),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.image, color: Colors.red),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      // ignore: prefer_const_literals_to_create_immutables
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showImageDialog();
            },
            child: CircleAvatar(
              radius: 80,
              backgroundImage: imageFile == null
                  ? AssetImage('images/avatar.png')
                  : Image.file(imageFile!).image,
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
          InputField(
              hintText: 'Enter name',
              icon: Icons.person_rounded,
              obscureText: false,
              text: nameController),
          InputField(
              hintText: 'Enter phone',
              icon: Icons.phone_rounded,
              obscureText: false,
              text: phoneController),
          SizedBox(height: 15.0),
          ButtonSignUp(
            text: 'Create account',
            press: () async {
              if (imageFile == null) {
                Fluttertoast.showToast(msg: 'Please select an img');
                return;
              }
              try {
                print('Create account tapped');
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('user_imgs')
                    .child(DateTime.now().toString() + '.jpg');
                await ref.putFile(imageFile!);
                imageUrl = await ref.getDownloadURL();
                await _auth.createUserWithEmailAndPassword(
                  email: emailController.text.trim().toLowerCase(),
                  password: passwordController.text.trim(),
                );
                final User? user = _auth.currentUser;
                final _uid = user!.uid;
                FirebaseFirestore.instance.collection('users').doc(_uid).set(
                  {
                    'id': _uid,
                    'userImage': imageUrl,
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'email': emailController.text,
                    'createdAt': Timestamp.now(),
                  },
                );
                Navigator.pushReplacementNamed(context, 'home');
              } catch (e) {
                Fluttertoast.showToast(
                  msg: e.toString(),
                );
                print(e);
              }
            },
            color1: Colors.red,
            color2: Colors.redAccent,
          ),
          SizedBox(height: 15.0),
          AccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacementNamed(context, 'login');
              })
        ],
      ),
    );
  }
}
