import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePicture extends StatefulWidget {
  ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture>{
  String? imageUrl; 

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
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
    return CircleAvatar(
      radius: 50,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : AssetImage("assets/images/placeholder.png") as ImageProvider,
    );
  }
}
