import 'package:flutter/material.dart';
import 'package:grad_project/screens/post/content/post_tags.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:grad_project/screens/post/post.dart';
import 'package:grad_project/Classes/Post.dart';
import 'package:grad_project/screens/post/content/post_header.dart';
import 'package:grad_project/screens/post/content/post_buttons.dart';
import 'package:grad_project/screens/post/content/post_media.dart';
import 'package:grad_project/screens/post/content/post_description.dart';

class PostContent extends StatelessWidget {
  final Post p;
  final String myId;
  PostContent(this.p, this.myId);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PostHeader(
          title: p.title,
          creatorsData: p.creatorsAvatarsAndIds,
          creatorsAreFollowed: p.creatorsAreFollowed,
          myId: myId,
        ),
        PostMedia(
          p.url,
          p.category,
        ),
        PostButtons(
          isLiked: p.inLikes,
          isFav: p.inFavs,
          viewCount: p.views,
          likeCount: p.likes,
          postId: p.postId,
        ),
        PostDescription(
          p.description,
        ),
        PostTags(
          p.tags,
        ),
      ],
    );
  }
}
