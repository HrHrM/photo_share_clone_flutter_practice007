// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinterest_clone_codingcafe/src/owner_details/owner_datails.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String changeTitle = 'Grid view';
  bool checkView = false;

  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void _uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: 'Please select img');
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_imgs')
          .child(DateTime.now().toString() + '.jpg');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('wallpaper')
          .doc(DateTime.now().toString())
          .set({
        'id': _auth.currentUser!.uid,
        'userImage': myImage,
        'name': myName,
        'email': _auth.currentUser!.email,
        'image': imageUrl,
        'downloads': 0,
        'created_at': DateTime.now(),
      });
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      imageFile = null;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void readUserInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) async {
      myImage = snapshot.get('userImage');
      myName = snapshot.get('name');
    });
  }

  Widget listViewWidget(String docId, String img, String userImg, String name,
      DateTime date, String userId, int downloads) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 16.0,
          shadowColor: Colors.white10,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.deepOrange.shade100],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                stops: const [0.2, 0.9],
              ),
            ),
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OwnerDetails(
                          img: img,
                          userImg: userImg,
                          userId: userId,
                          name: name,
                          docId: docId,
                          downloads: downloads,
                          date: date,
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(userImg),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            DateFormat('dd MMM, yyyy - hh:mm a')
                                .format(date)
                                .toString(),
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget gridViewWidget(String docId, String img, String userImg, String name,
      DateTime date, String userId, int downloads) {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(6.0),
      crossAxisSpacing: 1,
      crossAxisCount: 1,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange.shade100],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              stops: const [0.2, 0.9],
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              //
            },
            child: Center(
              child: Image.network(
                img,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    readUserInfo();
  }

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
          floatingActionButton: Wrap(
            direction: Axis.horizontal,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: '1',
                  backgroundColor: Colors.deepOrange.shade400,
                  onPressed: () {
                    _showImageDialog();
                  },
                  child: Icon(Icons.camera_enhance),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: '2',
                  backgroundColor: Colors.pink.shade400,
                  onPressed: () {
                    _uploadImage();
                  },
                  child: Icon(Icons.cloud_upload),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.deepOrange.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.2, 0.9],
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                setState(() {
                  changeTitle = 'List view';
                  checkView = true;
                });
              },
              onDoubleTap: () {
                setState(() {
                  changeTitle = 'Grid view';
                  checkView = false;
                });
              },
              child: Text(changeTitle),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: Icon(Icons.logout_rounded),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('wallpaper')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  if (checkView == true) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return listViewWidget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]['image'],
                          snapshot.data!.docs[index]['userImage'],
                          snapshot.data!.docs[index]['name'],
                          snapshot.data!.docs[index]['created_at'].toDate(),
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index]['downloads'],
                        );
                      },
                    );
                  } else {
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return gridViewWidget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]['image'],
                          snapshot.data!.docs[index]['userImage'],
                          snapshot.data!.docs[index]['name'],
                          snapshot.data!.docs[index]['created_at'].toDate(),
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index]['downloads'],
                        );
                      },
                    );
                  }
                } else {
                  return Center(
                    child: Text('There is no task'),
                  );
                }
              }
              return Center(
                child: Text('Error, smth went wrong'),
              );
            },
          ),
        ),
      ),
    );
  }
}
