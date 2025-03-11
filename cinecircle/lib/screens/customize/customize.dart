import 'package:flutter/material.dart';
import 'package:cinecircle/screens/customize/edit_user_field.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/services/firestore_service.dart';

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
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Edit Username",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
            EditFields(
              user: widget.user,
              onEditingFields:(String userId, String newBio) {
                 FirestoreService().updateUserField(userId, newBio: newBio); 
              }
            ),
          ],
        )
      )
    );
  }
}