import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/screens/post/small_post_preview.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/utils/text_styles.dart';

class MorePostsFromCreator extends StatefulWidget {
  final List<String> userIds;
  final String postId;
  MorePostsFromCreator(this.userIds, this.postId);

  @override
  _MorePostsFromCreatorState createState() => _MorePostsFromCreatorState();
}

class _MorePostsFromCreatorState extends State<MorePostsFromCreator> {
  List<List<String>> fetchedPosts = [];
  bool postsAreLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 15, top: 15),
      child: postsAreLoaded
          ? fetchedPosts.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'More from creator',
                      style: AppTextStyles.postScreenSectionTitle,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: fetchedPosts
                              .map((p) => SmallPostPreview(
                                    postId: p[0],
                                    previewUrl: p[1],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                )
              : Container( height: 0, width: 0,)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMorePostsFromUser();
  }

  fetchMorePostsFromUser() async {
    fetchedPosts = await Provider.of<PostProvider>(context, listen: false)
        .getMoreFromCreator(widget.userIds, widget.postId);
    setState(() {
      postsAreLoaded = true;
    });
  }
}
