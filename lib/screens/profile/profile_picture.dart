import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grad_project/screens/profile/my_profile.dart';
import 'package:grad_project/screens/profile/user_profile.dart';

class ProfilePictureAvatar extends StatelessWidget {
  final String picUrl;
  final String userId;
  final String myId;
  final double avatarSize;

  ProfilePictureAvatar({this.userId, this.picUrl, this.myId, this.avatarSize = 20});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        backgroundImage: NetworkImage(picUrl),
        radius: avatarSize,
      ),
      onTap: () {
        if(userId == myId){
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile()));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(uid: userId)));
        }
      },
    );
  }
}
