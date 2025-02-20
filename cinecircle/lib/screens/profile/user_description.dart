//Shows number of user's friends and has the follow button. (Maybe add user's friendlist?)

import 'package:flutter/material.dart';
import 'package:cinecircle/models/user.dart';

class UserDescription extends StatefulWidget{
    final User user;
    final Function onFriended;

    const UserDescription(
        required this.user,
        required this.onFriended,
        super.key
    );

    @override
    _UserDescriptionState createState() => _UserDescriptionState();
}

class _UserDescriptionState extends State<UserDescription>{
    @override
    Widget build(BuildContext context){
        
    }
}