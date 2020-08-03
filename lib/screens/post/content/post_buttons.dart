import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/utils/text_styles.dart';

class PostButtons extends StatefulWidget {
  bool isLiked;
  bool isFav;
  final int viewCount;
  int likeCount;
  final String postId;

  PostButtons(
      {this.isLiked, this.isFav, this.viewCount, this.likeCount, this.postId});

  @override
  _PostButtonsState createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  bool isLiked;
  bool isFav;
  int likeCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.isLiked;
    isFav = widget.isFav;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () async {
              var msg;
              if (isLiked) {
                try {
                  msg = await Provider.of<PostProvider>(context, listen: false)
                      .deleteFromLikes(widget.postId);
                  setState(() {
                    isLiked = !isLiked;
                    likeCount = likeCount - 1;
                  });
                } catch (e) {
                  print(e.message);
                  msg = "An error occured";
                }
              } else {
                try {
                  msg = await Provider.of<PostProvider>(context, listen: false)
                      .addToLikes(widget.postId);
                  setState(() {
                    isLiked = !isLiked;
                    likeCount = likeCount + 1;
                  });
                } catch (e) {
                  print(e.message);
                  msg = "An error occured";
                }
              }

              if (msg != null) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(msg),
                  duration: Duration(seconds: 1),
                ));
              }
            },
          ),
          Text(
            likeCount.toString(),
            style: AppTextStyles.postScreenPostNumbers,
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(icon: Icon(Icons.remove_red_eye)),
          Text(
            widget.viewCount.toString(),
            style: AppTextStyles.postScreenPostNumbers,
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              color: isFav ? Colors.yellow : Colors.grey,
            ),
            onPressed: () async {
              var msg;
              if (isFav) {
                try {
                  msg = await Provider.of<PostProvider>(context, listen: false)
                      .deleteFromFavs(widget.postId);
                  setState(() {
                    isFav = !isFav;
                  });
                } catch (e) {
                  print(e.message);
                  msg = "An error occured";
                }
              } else {
                try {
                  msg = await Provider.of<PostProvider>(context, listen: false)
                      .addToFavs(widget.postId);
                  setState(() {
                    isFav = !isFav;
                  });
                } catch (e) {
                  print(e.message);
                  msg = "An error occured";
                }
              }
              if (msg != null) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(msg),
                  duration: Duration(seconds: 1),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
