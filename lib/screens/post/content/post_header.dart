import 'package:flutter/material.dart';
import 'package:grad_project/screens/profile/my_profile.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:grad_project/screens/profile/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';

class PostHeader extends StatefulWidget {
  final List<List<String>> creatorsData;
  final List<bool> creatorsAreFollowed;
  final String title;
  final String myId;

  PostHeader(
      {this.creatorsData, this.title, this.creatorsAreFollowed, this.myId});

  @override
  _PostHeaderState createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  bool multipleUsers = false;
  List<bool> creatorsAreFollowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ProfilePictureAvatar(
            picUrl: widget.creatorsData[0][2],
            userId: widget.creatorsData[0][1],
            avatarSize: 24,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: AppTextStyles.postScreenPostTitle,
                    overflow: TextOverflow.fade,
                  ),
                  multipleUsers ? _multipleUserNames() : _oneUserName(),
                ],
              ),
            ),
          ),
          !multipleUsers && widget.creatorsData[0][1] == widget.myId
              ? Container()
              : FlatButton(
                  child: Text('Follow'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () async {
                    if (!multipleUsers) {
                      print('follow 1 user');
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return FollowPopUp(widget.creatorsData,
                              creatorsAreFollowed, widget.myId);
                        },
                      );
                    }
                  },
                )
        ],
      ),
    );
  }

  Widget _oneUserName() {
    return Text('by ${widget.creatorsData[0][0]}');
  }

  Widget _multipleUserNames() {
    return Text(
      'by ${widget.creatorsData[0][0]} and ${widget.creatorsData.length - 1} collaborators',
      overflow: TextOverflow.fade,
    );
  }

  @override
  void initState() {
    super.initState();
    creatorsAreFollowed = widget.creatorsAreFollowed;
    multipleUsers = widget.creatorsData.length > 1;
  }
}

class FollowPopUp extends StatefulWidget {
  final List<List<String>> creatorsData;
  final List<bool> creatorsAreFollowed;
  final String myId;

  FollowPopUp(this.creatorsData, this.creatorsAreFollowed, this.myId);

  @override
  _FollowPopUpState createState() => _FollowPopUpState();
}

class _FollowPopUpState extends State<FollowPopUp> {
  List<bool> creatorsAreFollowed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: widget.creatorsData.asMap().entries.map((entry) {
          var userIndex = entry.key;
          var u = entry.value;
          return Row(
            children: <Widget>[
              ProfilePictureAvatar(
                picUrl: u[2],
                userId: u[1],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(u[0]),
              )),
              u[1] == widget.myId
                  ? Container()
                  : creatorsAreFollowed[userIndex]
                      ? _unFollowButton(u[1], userIndex)
                      : _followButton(u[1], userIndex),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _followButton(String userId, int i) {
    return FlatButton(
      child: Text('Follow'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.blue)),
      onPressed: () async {
        await Provider.of<PostProvider>(context, listen: false)
            .followUser(userId);
        setState(() {
          creatorsAreFollowed[i] = true;
        });
      },
    );
  }

  Widget _unFollowButton(String userId, int i) {
    return FlatButton(
      child: Text('Unfollow'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.blue)),
      onPressed: () async {
        await Provider.of<PostProvider>(context).unFollowUser(userId);
        setState(() {
          creatorsAreFollowed[i] = false;
        });
        print('unfollow');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    creatorsAreFollowed = widget.creatorsAreFollowed;
  }
}
