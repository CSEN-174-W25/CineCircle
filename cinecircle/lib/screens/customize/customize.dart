import 'package:flutter/material.dart';
import 'package:cinecircle/screens/customize/edit_user_field.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/models/profile_pic.dart';
import 'package:cinecircle/services/firestore_service.dart';
import 'package:cinecircle/screens/customize/add_fav.dart';
import 'package:cinecircle/screens/customize/pic_uploader.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Customize extends StatefulWidget {
  final User user;

  const Customize({
    required this.user,
    super.key
  });

  @override
  _CustomizeState createState() => _CustomizeState();
}

class _CustomizeState extends State<Customize> {
  File? _image; // Store the picked image file

  final picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Save the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Inter Tight",
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 52, 52),
                  Color.fromARGB(255, 194, 0, 161)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding value
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Enter Profile Picture URL",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            ProfilePicture(user: widget.user),
            SizedBox(height: 10),
            EditFields(
              user: widget.user,
              onEditingFields:(String userId, String newPic) {
                 FirestoreService().updateUserField(userId, newPic: newPic); 
              }
            ),
            SizedBox(height: 20),
            Text(
              "Edit Username",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            EditFields(
              user: widget.user,
              onEditingFields:(String userId, String newUsername) {
                 FirestoreService().updateUserField(userId, newUsername: newUsername); 
              }
            ),
            SizedBox(height: 20),
            Text(
              "Edit Bio",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            EditFields(
              user: widget.user,
              onEditingFields:(String userId, String newBio) {
                 FirestoreService().updateUserField(userId, newBio: newBio); 
              }
            ),
            SizedBox(height: 20),
            Text(
              "Select Favorite Media",
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddFav(
                  user: widget.user,
                  index: 0,
                ),
                SizedBox(width: 2),
                AddFav(
                  user: widget.user,
                  index: 1,
                ),
                SizedBox(width: 2),
                AddFav(
                  user: widget.user,
                  index: 2,
                ),
                SizedBox(width: 2),
                AddFav(
                  user: widget.user,
                  index: 3,
                ),
              ]
            ),
            SizedBox(height: 40),
          ],
        )
        )
      )
    );
  }
}
