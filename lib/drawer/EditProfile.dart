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

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance.currentUser!;
  final store = FirebaseFirestore.instance;

  final _form = GlobalKey<FormState>();
  late var _username = TextEditingController();
  late var _firstname = TextEditingController();
  late var _lastname = TextEditingController();
  late var _address = TextEditingController();
  late var _tel = TextEditingController();
  String imageurl = '';
  ImagePicker imagePicker = ImagePicker();
  File? _image;
  File? get image => _image;
  File? _image1;

  final _usersStream = FirebaseFirestore.instance
      .collection('Profile')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  dynamic _model;
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
            return const Text("Loading");
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          _model = data;

          _username.text = data['username'];
          _firstname.text = data['firstname'];
          _lastname.text = data['lastname'];
          _tel.text = data['tel'];
          _address.text = data['address'];

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 142, 185, 255),
              title: const Text('Profile'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 142, 185, 255),
                Color.fromARGB(255, 191, 218, 255),
                Color.fromARGB(255, 120, 169, 255)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    ShowImage(context),
                    buildUserNameField(),
                    buildFirstNameField(),
                    buildLastNameField(),
                    buildAddressField(),
                    buildTelField(),
                    buildSaveButton()
                  ],
                ),
              ),
            ),
          );
        });
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
        child: const Text('Save'),
        onPressed: () async {
          if (_form.currentState!.validate()) {
            print('save button press');
            Map<String, dynamic> data = {
              'username': _username.text,
              'firstname': _firstname.text,
              'lastname': _lastname.text,
              'address': _address.text,
              'tel': _tel.text,
            };
            try {
              FirebaseFirestore.instance
                  .collection("Profile")
                  .doc(_auth.uid)
                  .update(data);
              //print('save id = ${ref.id}');

              Navigator.pop(context, '/Profile');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error $e'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please validate value'),
              ),
            );
          }
        });
  }

  TextFormField buildUserNameField() {
    return TextFormField(
      controller: _username,
      decoration: const InputDecoration(
        labelText: 'UserName',
        icon: Icon(Icons.person),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in title' : null,
    );
  }

  TextFormField buildFirstNameField() {
    return TextFormField(
      controller: _firstname,
      decoration: const InputDecoration(
        labelText: 'First name',
        icon: Icon(Icons.person_pin_sharp),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildLastNameField() {
    return TextFormField(
      controller: _lastname,
      decoration: const InputDecoration(
        labelText: 'Last name',
        icon: Icon(Icons.person_pin_sharp),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildAddressField() {
    return TextFormField(
      controller: _address,
      decoration: const InputDecoration(
        labelText: 'Address',
        icon: Icon(Icons.home),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  TextFormField buildTelField() {
    return TextFormField(
        controller: _tel,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Telephone',
          icon: Icon(Icons.phone),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill in tel';
          } else {
            double tel = double.parse(value);
            if (tel < 0) {
              return 'Please fill in tel';
            } else {
              return null;
            }
          }
        });
  }

  Future pickGallereImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    print('${PickedFile?.path}');
    print('sssssssssssss');
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
        print('${image?.path}');
        _image1 = image;
      }
      uploadImage(context);
    });
  }

  Future pickCameraImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
        print('${image?.path}');
      }
      uploadImage(context);
    });
  }

  Stack ShowImage(context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: image == null
                    ? Image.network(
                        _model['urlprofile'].toString(),
                        fit: BoxFit.fill,
                      )
                    : Image.file(image!, fit: BoxFit.fill),
                // Image.network(
                //     _model['urlprofile'].toString(),
                //     fit: BoxFit.fill,
                //   ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            pickImage(context);
          },
          child: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  File? pickImage(context) {
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
    final picker = ImagePicker();
    File? _file = image;
    if (image == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('image');

    Reference referenceImageToUpload = referenceDirImages.child(_auth.uid);
    referenceImageToUpload.putFile(_file!);
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
    await FirebaseFirestore.instance
        .collection("Profile")
        .doc(_auth.uid)
        .set(data);
    //referenceImageToUpload.putFile(File(_file!.path));
  }
}
