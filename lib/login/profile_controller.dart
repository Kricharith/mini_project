import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileController with ChangeNotifier {
  final _auth = FirebaseAuth.instance.currentUser!;
  final store = FirebaseFirestore.instance;
  ImagePicker imagePicker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  Future pickGallereImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    print('${PickedFile?.path}');
    print('sssssssssssss');
    if (PickedFile != null) {
      _image = XFile(PickedFile.path);
      print('${image?.path}');
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final PickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    if (PickedFile != null) {
      _image = XFile(PickedFile.path);
      print('${image?.path}');
      notifyListeners();
    }
  }

  void pickImage(context) {
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
                      Navigator.pop(context);
                      pickGallereImage(context);
                    },
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                  )
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(BuildContext context) async {
    // firebase_storage.Reference storagerRef =
    //     firebase_storage.FirebaseStorage.instance.ref('/profileImage'+Session);
    final picker = ImagePicker();
    XFile? _file = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('image');

    Reference referenceImageToUpload = referenceDirImages.child(_auth.uid);

    //referenceImageToUpload.putFile(File(_file!.path));
  }
}
