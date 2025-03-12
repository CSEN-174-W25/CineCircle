import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinecircle/models/profile_pic.dart';

class ProfilePictureUploader extends StatefulWidget {
  @override
  _ProfilePictureUploaderState createState() => _ProfilePictureUploaderState();
}

class _ProfilePictureUploaderState extends State<ProfilePictureUploader> {
  String? imageUrl; 

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');

    try {
      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });


    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _loadProfilePicture() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      String downloadUrl = await FirebaseStorage.instance.ref('profile_pictures/$userId.jpg').getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      print("Error loading profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*
        CircleAvatar(
          radius: 50,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : AssetImage("assets/images/placeholder.png") as ImageProvider,
        ),*/
        ProfilePicture(),
        ElevatedButton(
          onPressed: _uploadImage,
          child: Text("Upload New Profile Picture"),
        ),
      ],
    );
  }
}
