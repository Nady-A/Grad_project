import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/Classes/Comment.dart';
import 'package:grad_project/screens/profile/profile_picture.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final String myId;
  final String myProfilePic;
  final String myUserName;

  CommentSection(this.postId, this.myId, this.myProfilePic, this.myUserName);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool commentsAreLoaded = false;
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  Widget build(BuildContext context) {
    print('BUILDING COMMENT SECTION');
    print(commentsAreLoaded);
    print(comments);
    print(widget.myId);
    print(widget.postId);
    print(widget.myProfilePic);
    print(widget.myUserName);
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15),
      child: commentsAreLoaded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Comments',
                  style: AppTextStyles.postScreenSectionTitle,
                ),
                ListTile(
                  leading: ProfilePictureAvatar(
                    picUrl: widget.myProfilePic,
                    userId: widget.myId,
                  ),
                  title: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Add comment...',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (commentController.value.text.isEmpty) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Comment can not be empty'),
                          ),
                        );
                        return;
                      }
                      var commentId = await Provider.of<PostProvider>(context)
                          .addComment(
                              commentController.value.text, widget.postId);
                      Comment c = Comment(
                          commentText: commentController.value.text,
                          userId: widget.myId);
                      c.commentId = commentId;
                      c.userName = widget.myUserName;
                      c.profilePic = widget.myProfilePic;
                      setState(() {
                        comments.insert(0, c);
                      });
                      commentController.text = '';
                    },
                  ),
                ),
                Column(
                  //shrinkWrap: true,
                  children: comments.map((c) => _buildComment(c)).toList(),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  fetchComments() async {
    comments = await Provider.of<PostProvider>(context, listen: false)
        .getComments(widget.postId);
    setState(() {
      commentsAreLoaded = true;
    });
  }

  Widget _buildComment(Comment c) {
   return ListTile(
      leading: ProfilePictureAvatar(
        picUrl: c.profilePic,
        userId: c.userId,
      ),
      title: Text(c.userName),
      subtitle: Text(c.commentText),
      trailing: c.userId == widget.myId
          ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                await Provider.of<PostProvider>(context)
                    .deleteComment(widget.postId, c.commentId);
                setState(() {
                  comments.remove(c);
                });
              },
            )
          : Container(width: 0, height: 0,),
    );
  }
}
