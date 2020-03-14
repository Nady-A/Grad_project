import 'dart:math';

import 'package:flutter/material.dart';

class ProfilePictureAvatar extends StatelessWidget {
  final String picUrl;
  final String userId;
  final double avatarSize;

  ProfilePictureAvatar({this.userId, this.picUrl, this.avatarSize = 20});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        backgroundImage: NetworkImage(picUrl),
        radius: avatarSize,
      ),
      onTap: () {
        print(userId);
      },
    );
  }
}
