import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';

class PostDescription extends StatelessWidget {
  final String description;
  PostDescription(this.description);
  @override
  Widget build(BuildContext context) {
    return description.isNotEmpty ? Container(
      margin: EdgeInsets.only(left: 15),
      child: Text(
        description,
        style: AppTextStyles.postScreenDescription,
      ),
    ): Container(width: 0, height: 0,);
  }
}
