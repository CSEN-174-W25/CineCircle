import 'package:flutter/material.dart';
import 'package:cinecircle/widgets/fav.dart';
import 'package:cinecircle/models/user.dart';
import 'package:cinecircle/screens/customize/adding_fav/fav_search.dart';

class AddFav extends StatefulWidget{
  final User user;
  final int index;

  AddFav({
    required this.user,
    required this.index,
    super.key
  });

  @override
  _AddFavState createState() => _AddFavState();
}

class _AddFavState extends State<AddFav> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector( 
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavSearch(user: widget.user, index: widget.index), 
              ),
            );
          },
         
          child: Fav(user: widget.user, index: widget.index),
          
      )]
    );
  }
}

