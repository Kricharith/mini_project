import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/login/profile_controller.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ImagePicker imagePicker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;
  ProfileController _profile = ProfileController();

  //final ref = FirebaseFirestore.instance.collection("Profile");
  final store = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser!;
  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  dynamic _model;
  String imageurl = '';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        _model = data;
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 130, 157, 255),
              centerTitle: true,
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 35),
              ),
              actions: <Widget>[
                buildAddButton(context),
                //buildDeleteButton(context)
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 130, 157, 255),
                Color.fromARGB(255, 240, 243, 252),
                Color.fromARGB(255, 126, 147, 255)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(children: [
                ShowProfile(context),
              ]),
            ));
      },
    );
  }

  IconButton buildAddButton(context) {
    return IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          print("add icon press");
          Navigator.pushNamed(context, '/EditProfile');
        });
  }

  Column ShowProfile(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: _model['urlprofile'].toString() == ""
                          ? Image(
                              image: NetworkImage(
                                  'https://icons.veryicon.com/png/o/miscellaneous/management-system-icon-library/person-15.png'))
                          : Image.network(
                              _model['urlprofile'].toString(),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 89, 205, 255),
              ),
              child: Row(
                children: [
                  SizedBox(width: 1),
                  Icon(Icons.person, size: 30),
                  SizedBox(width: 15),
                  Text(_model['username'].toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 89, 205, 255),
              ),
              child: Row(
                children: [
                  SizedBox(width: 1),
                  Icon(Icons.person, size: 30),
                  SizedBox(width: 15),
                  Text(
                      _model['firstname'].toString() +
                          '  ' +
                          _model['lastname'].toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              height: 110,
              width: 350,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 89, 205, 255),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.home, size: 30),
                    ],
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Text(_model['address'].toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 25)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              width: 350,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 89, 205, 255),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.phone, size: 30),
                  SizedBox(
                    width: 10,
                  ),
                  Text(_model['tel'].toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 25)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future pickGallereImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    print('${PickedFile?.path}');
    print('sssssssssssss');
    setState(() {
      if (PickedFile != null) {
        _image = XFile(PickedFile.path);
        print('${image?.path}');
      }
    });
  }

  Future pickCameraImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (PickedFile != null) {
        _image = XFile(PickedFile.path);
        print('${image?.path}');
      }
    });
  }

  XFile? pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      pickGallereImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                  )
                ],
              ),
            ),
          );
        });
    setState(() {});
    return image;
  }

  void uploadImage(BuildContext context) async {
    // firebase_storage.Reference storagerRef =
    //     firebase_storage.FirebaseStorage.instance.ref('/profileImage'+Session);
    final picker = ImagePicker();
    XFile? _file = image;
    if (image == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('image');

    Reference referenceImageToUpload = referenceDirImages.child(_auth.uid);
    try {} catch (error) {}
    referenceImageToUpload.putFile(File(_file!.path));
    imageurl = await referenceImageToUpload.getDownloadURL();
    print("ssssssssssssssssssssssssssssssss");
    Map<String, dynamic> data = {
      'username': _model['username'],
      'firstname': _model['firstname'],
      'lastname': _model['lastname'],
      'address': _model['address'],
      'tel': _model['tel'],
      'urlprofile': imageurl,
      //'tel': int.parse(_tel.text)
    };
    FirebaseFirestore.instance.collection("Profile").doc(_auth.uid).set(data);
    //referenceImageToUpload.putFile(File(_file!.path));
  }
}
