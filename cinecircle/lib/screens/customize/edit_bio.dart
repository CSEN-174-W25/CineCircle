import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

class EditBio extends StatefulWidget {
  final User user;

    EditBio ({
      required this.user,
      super.key
    });

  @override
  _EditBioState createState() => _EditBioState();  
}

class _EditBioState extends State<EditBio>{
  final TextEditingController _controller = TextEditingController();
  double textBoxHeight = 50;

  @override
  Widget build(BuildContext context){
    return Column (
      children: [
        ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              child: SizedBox(
                height: textBoxHeight,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (text) {
                    setState(() {
                      textBoxHeight = (text.split("\n").length * 20.0).clamp(50.0, 200.0);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Edit Bio...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: ,
          child: Text("Update"),
        ),
      ]
    );
  }
}