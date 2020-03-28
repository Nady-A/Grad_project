import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/screens/profile/post_card.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';

FirebaseUser currentUser;
Firestore fs = Firestore.instance;
Map<String, dynamic> data;
QuerySnapshot posts;
bool isFollowed;
bool isFollowing;

class UserProfile extends StatefulWidget {
  final String uid;

  UserProfile({@required this.uid});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return isLoaded ? Profile(uid: widget.uid) : Center(child: CircularProgressIndicator());
  }

  getData() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    data = await fs.collection('users').document(widget.uid).get().then((x) {
      return x.data;
    });
    posts = await fs.collection('posts').orderBy('created_at', descending: true).where('user_id', arrayContains: widget.uid).getDocuments();
    setState(() {
      isLoaded = true;
    });

    await fs.collection('users').document(currentUser.uid).collection('my_followers').document(widget.uid).get().then((x){
      if(x.exists){
        setState(() {
          isFollowing = true;
        });
      }
      else if(!x.exists){
        setState(() {
          isFollowing = false;
        });
      }
    }
    );

    await fs.collection('users').document(currentUser.uid).collection('following').document(widget.uid).get().then((x){
    if(x.exists){
      setState(() {
        isFollowed = true;
      });
    }
    else if(!x.exists){
      setState(() {
        isFollowed = false;
      });
    }
  }
  );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
}

class Profile extends StatefulWidget {
  final String uid;

  Profile({@required this.uid});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)
              ),
            ),
            floating: true,
            expandedHeight: x.height / 1.7,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileHeader(uid: widget.uid),
            ),
          ),
          SliverList(
            delegate: posts.documents.length != 0 ? SliverChildBuilderDelegate(
              (context, index) => Post(
                post: posts.documents[index],
                uid: currentUser.uid,
              ),
              childCount: posts.documents.length,
            ) : SliverChildListDelegate(<Widget>[Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User has no posts',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )])
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  final String uid;

  ProfileHeader({@required this.uid});
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CoverProfilePicName(x: x),
            EditProfileButton(x: x, uid: widget.uid),
            SizedBox(height: x.height / 15),
            Bio(),
            Center(child: Stats(x: x)),
          ],
        ),
      ),
    );
  }
}

class EditProfileButton extends StatefulWidget {
  const EditProfileButton({
    Key key,
    @required this.x,
    @required this.uid,
  }) : super(key: key);

  final Size x;
  final String uid;

  @override
  _EditProfileButtonState createState() => _EditProfileButtonState();
}

class _EditProfileButtonState extends State<EditProfileButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: widget.x.width / (widget.x.width / 8)),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () async{
                if(isFollowed){
                  await Provider.of<PostProvider>(context, listen: false).unFollowUser(widget.uid);
                  print('unfollow');
                  setState(() {
                    isFollowed = !isFollowed;
                  });
                }
                else{
                  await Provider.of<PostProvider>(context, listen: false).followUser(widget.uid);
                  print('follow');
                  setState(() {
                    isFollowed = !isFollowed;
                  });
                }
              },
              child: isFollowed !=null? isFollowed? Text('Unfollow') : Text('Follow') : Container(width: 0, height: 0,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.blue),
              ),
            ),
          Container(
            child: isFollowing != null ? isFollowing? Container(
              // onLongPress: (){},
              // child: Icon(Icons.undo),
              width: 80,
              height: 18,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2)
              ),
              child: Text(
                'Follows you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700]
                ),
              ),
            ) : Container(width: 0, height: 0) : Container(width: 0, height: 0),
          ),
          ],
        ),
      ),
    );
  }
}

class Bio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              data['bio'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NameLocation extends StatelessWidget {
  NameLocation({
    @required this.x,
  });

  final Size x;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          data['name'],
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
      Text(
        'Alexandria, Egypt',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      ],
    );
  }
}

class Stats extends StatelessWidget {
  Stats({@required this.x});
  final Size x;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: x.width / 1.1,
      height: x.height / 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StatSection(
            count: data['post_count'].toString(),
            label: 'Posts',
          ),
          StatSection(
            count: data['follower_count'].toString(),
            label: 'Followers',
          ),
          StatSection(
            count: data['following_count'].toString(),
            label: 'Following',
          ),
        ],
      ),
    );
  }
}

class StatSection extends StatelessWidget {
  StatSection({@required this.count, @required this.label});

  final String label;
  final String count;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CoverProfilePicName extends StatelessWidget {
  CoverProfilePicName({@required this.x});

  final Size x;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: x.height / 4.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data['cover_picture_url']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: x.width / 10,
            left: x.width / (x.width / 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: x.width / 2.75,
                  height: x.width / 2.75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(data['profile_picture_url']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.grey[800],
                      width: 3,
                    ),
                  ),
                ),
                NameLocation(x: x),
              ],
            ),
          ),
        ],
      ),
    );
  }
}