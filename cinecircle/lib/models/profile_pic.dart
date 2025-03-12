import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinecircle/models/user.dart';

class ProfilePicture extends StatefulWidget {
  final User user;

  ProfilePicture({required this.user, super.key});

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
  //String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.userId)
        .get();

    if (userDoc.exists) {
      print("Document data: ${userDoc.data()}"); //!userDoc.data().toString().contains('topFour')
      if (userDoc.data() != null && userDoc.data()!.toString().contains('picUrl')) {
        setState(() {
          imageUrl = userDoc['picUrl']; // Get the URL from the picURL field
        });
      } else {
        print("Field 'picURL' does not exist in the document.");
      }
    } else {
      print("User document does not exist.");
    }
  } catch (e) {
    print("Error loading profile picture: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(widget.user.picUrl)
          : AssetImage("assets/images/placeholder.png") as ImageProvider,
    );
  }
}
