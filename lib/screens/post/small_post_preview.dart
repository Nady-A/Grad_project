import 'package:flutter/material.dart';
import 'package:grad_project/screens/post/post.dart';

class SmallPostPreview extends StatelessWidget {
  final previewUrl;
  final postId;

  SmallPostPreview({this.postId, this.previewUrl});

  @override
  Widget build(BuildContext context) {
    //double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostScreen(postId)));
      },
      child: Container(
        //color: Colors.grey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
        ),
        margin: EdgeInsets.only(right: 25),
        width: w / 2,
        height: w / 2,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: previewUrl,
                //fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}
