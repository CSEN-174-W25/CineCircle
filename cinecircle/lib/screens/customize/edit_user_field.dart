import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

class EditFields extends StatefulWidget {
  final User user;
  final Function(String, String) onEditingFields;
  
   EditFields ({
    required this.user,
    required this.onEditingFields,
    super.key
    });

  @override
  _EditFieldsState createState() => _EditFieldsState();  
}

class _EditFieldsState extends State<EditFields>{
  final TextEditingController _controller = TextEditingController();
  double textBoxHeight = 50;

  void _updateBio() {
    if (_controller.text.isEmpty) return;

    widget.onEditingFields(widget.user.userId, _controller.text);
    _controller.clear();

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          textBoxHeight = 50;
        });
      }
    });
  }

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
                    hintText: "Input Text...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _updateBio,
          child: Text("Update"),
        ),
      ]
    );
  }
}