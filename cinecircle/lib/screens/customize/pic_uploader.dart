import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cinecircle/models/profile_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/services/firestore_service.dart';
import 'package:cinecircle/models/user.dart';

class ProfilePictureUploader extends StatefulWidget {
  final String userId;
  final User user; // Assuming userId is passed to the widget

  ProfilePictureUploader({required this.userId, required this.user});
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
    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
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
  /*
  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');

    try {
      // Upload the image to Firebase Storage
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadUrl = await ref.getDownloadURL();

      // Store the URL in Firestore (update the user's document with the new profile picture)
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': downloadUrl, // Add a 'profilePicture' field to store the URL
      });

      // Update the state with the new image URL
      setState(() {
        imageUrl = downloadUrl;
      });

      print("Image uploaded successfully!");

    } catch (e) {
      print("Error uploading image: $e");
    }
  }*/
  

  //TextEditingController _urlController = TextEditingController();

  Future<void> _loadProfilePicture() async {
    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
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
        ProfilePicture(user: widget.user),
        ElevatedButton(
          onPressed: _uploadImage,
          child: Text("Upload New Profile Picture"),
        ),
      ],
    );
  }
}
