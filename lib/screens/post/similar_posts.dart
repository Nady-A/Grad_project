import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/screens/post/small_post_preview.dart';
import 'package:provider/provider.dart';

class SimilarPosts extends StatefulWidget {
  final String category;
  final String postId;
  SimilarPosts(this.category, this.postId);

  @override
  _SimilarPostsState createState() => _SimilarPostsState();
}

class _SimilarPostsState extends State<SimilarPosts> {
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
                      'Explore more ${widget.category.toLowerCase()}',
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
              : Container()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSimilarPosts();
  }

  fetchSimilarPosts() async {
    fetchedPosts = await Provider.of<PostProvider>(context, listen: false)
        .getSimilarPosts(widget.category, widget.postId);
    setState(() {
      postsAreLoaded = true;
    });
  }
}
