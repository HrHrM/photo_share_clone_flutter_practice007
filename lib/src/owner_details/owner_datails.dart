// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:pinterest_clone_codingcafe/widgets/button_signup.dart';

class OwnerDetails extends StatefulWidget {
  const OwnerDetails({
    Key? key,
    this.img,
    this.userId,
    this.date,
    this.docId,
    this.downloads,
    this.name,
    this.userImg,
  }) : super(key: key);

  final String? img;
  final String? userImg;
  final String? name;
  final DateTime? date;
  final String? docId;
  final String? userId;
  final int? downloads;

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange.shade100],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              stops: const [0.2, 0.9],
            ),
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                          child: Image.network(
                            widget.img!,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Owner Information',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.userImg!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Uploaded by: ' + widget.name!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    DateFormat('dd MMM, yyyy - hh:mm a')
                        .format(widget.date!)
                        .toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                      Text(
                        '' + widget.downloads.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ButtonSignUp(
                      text: "Download pic",
                      color1: Colors.green,
                      color2: Colors.lightGreen,
                      press: () async {
                        try {
                          var imageId =
                              await ImageDownloader.downloadImage(widget.img!);
                          if (imageId == null) {
                            return;
                          }
                          Fluttertoast.showToast(
                              msg: 'Image saved to the gallery');
                          var total = widget.downloads! + 1;
                          FirebaseFirestore.instance
                              .collection('wallpaper')
                              .doc(widget.docId)
                              .update(
                            {'downloads': total},
                          ).then((value) {
                            Navigator.pushReplacementNamed(context, 'home');
                          });
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  FirebaseAuth.instance.currentUser!.uid == widget.userId!
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: ButtonSignUp(
                            color1: Colors.green,
                            color2: Colors.white,
                            text: 'Delete',
                            press: () async {
                              FirebaseFirestore.instance
                                  .collection('wallpaper')
                                  .doc(widget.docId!)
                                  .delete()
                                  .then((value) {
                                Navigator.pushReplacementNamed(context, 'home');
                              });
                            },
                          ),
                        )
                      : Container(),
                  SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
