import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/Classes/AppDrawer.dart';
import 'package:grad_project/screens/profile/edit_profile.dart';
import 'package:grad_project/screens/profile/post_card.dart';

FirebaseUser currentUser;
Firestore fs = Firestore.instance;
Map<String, dynamic> data;
QuerySnapshot posts;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return isLoaded ? Scaffold(
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoaded = false;
          });
          getData();
        },
        child: CustomScrollView(
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
              expandedHeight: x.width,
              flexibleSpace: FlexibleSpaceBar(
                background: ProfileHeader(),
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
      ),
    ) : Center(child: CircularProgressIndicator());
  }

  getData() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    data = await fs.collection('users').document(currentUser.uid).get().then((x) {
      return x.data;
    });
    posts = await fs.collection('posts').orderBy('created_at', descending: true).where('user_id', arrayContains: currentUser.uid).getDocuments();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
}

class ProfileHeader extends StatefulWidget {
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
            EditProfileButton(x: x),
            SizedBox(height: x.width / 10),
            Bio(),
            Center(child: Stats(x: x)),
          ],
        ),
      ),
    );
  }
}

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({
    Key key,
    @required this.x,
  }) : super(key: key);

  final Size x;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: x.width / (x.width / 8)),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(uid: currentUser.uid,)));
          },
          child: Text('Edit Profile'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.blue),
          ),
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
      // Text(
      //   'Alexandria, Egypt',
      //   textAlign: TextAlign.center,
      //   style: TextStyle(
      //     fontSize: 15,
      //   ),
      // ),
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
      height: x.width / 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StatSection(
            count: posts.documents.length.toString(),
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
            height: x.width / 2.6,
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