import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseUser currentUser;
Firestore fs = Firestore.instance;
Map<String, dynamic> data;
getData() async {
  currentUser = await FirebaseAuth.instance.currentUser();
  data = await fs.collection('users').document(currentUser.uid).get().then((x) {
    return x.data;
  });
}

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    getData();
    return data != null ? Profile() : Loading();
  }
}

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.blue,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(),
            title: Text('My Profile'),
            floating: true,
            expandedHeight: x.height / 1.92,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileHeader(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => Post(),),
          ),
        ],
      ),
    );
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CoverProfilePic(x: x),
            SizedBox(height: x.height / 13,),
            UserInfo(x: x),
            SizedBox(height: x.height / 100,),
            Stats(x: x),
          ],
        ),
      ),
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

class UserInfo extends StatelessWidget {
  UserInfo({@required this.x});

  final Size x;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: x.width / 1.5,
      child: Column(
        children: <Widget>[
          Text(
            data['name'],
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            data['bio'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Alexandria, Egypt',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CoverProfilePic extends StatelessWidget {
  CoverProfilePic({@required this.x});

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
                image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/talentapp-dc5b9.appspot.com/o/avatars%2Fcover.jpg?alt=media&token=f0f704c8-71b9-493c-a4cf-d6ef5da57396'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: x.height / 20,
            left: x.width / 3.45,
            child: Container(
              width: x.height / 4,
              height: x.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data['profile_picture_url']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.blue[900],
                  width: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){print('go to post');},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 375,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
        ),
      );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Loading...'),
    );
  }
}