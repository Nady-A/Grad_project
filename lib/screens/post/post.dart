import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/utils/post_screen_arguments.dart';
import 'package:grad_project/Classes/Post.dart';
import 'package:provider/provider.dart';
import 'content/content.dart';
import 'more_from_user.dart';
import 'similar_posts.dart';
import 'comment_section.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  PostScreen(this.postId);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _postIsLoaded = false;
  Post p;
  String myId;
  String myProfilePic;
  String myUserName;

  @override
  Widget build(BuildContext context) {
    print('Building post screen ' + widget.postId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _postIsLoaded
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  PostContent(p, myId),
                  MorePostsFromCreator(p.userId, p.postId),
                  SimilarPosts(p.category, p.postId),
                  CommentSection(p.postId, myId, myProfilePic, myUserName),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void initState() {
    super.initState();
    fetchPostAndChangeState();
  }

  void fetchPostAndChangeState() async {
    try {
      p = await Provider.of<PostProvider>(context, listen: false).getPost(widget.postId);
      myId = await Provider.of<PostProvider>(context, listen: false).getMyId();
      myProfilePic = await Provider.of<PostProvider>(context, listen: false).getMyProfilePicture();
      myUserName = await Provider.of<PostProvider>(context, listen: false).getMyUserName();
      setState(() {
        _postIsLoaded = true;
      });
      //print(p);
    } catch (e) {
      print(e);
      print('error occured while fetching post');
    }
  }

  void dispose() {
    print('disposing of ' + widget.postId);
    //postProv.reset();
    super.dispose();
  }
}
