import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';

class PostTags extends StatelessWidget {
  final List<String> tags;
  PostTags(this.tags);

  @override
  Widget build(BuildContext context) {
    //List<String> tags = Provider.of<PostProvider>(context).post.
    return Container(
      margin: EdgeInsets.only(left: 15 , bottom: 5 , top: 5),
      child: tags.length > 1
          ? SingleChildScrollView(
              child: Row(
                children: tags.map((t) => _buildTagItem(t)).toList(),
              ),
            )
          : Container(),
    );
  }

  Widget _buildTagItem(String tag) {
    return Container(
      margin: EdgeInsets.only(right: 15, top: 15),
      padding: EdgeInsets.only(right: 10, left: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color.fromRGBO(0, 0, 255, 1),
        ),
      ),
      child: Text(
        tag,
        style: AppTextStyles.postScreenTag,
      ),
    );
  }
}
