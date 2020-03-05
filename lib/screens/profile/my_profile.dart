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

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getData();
    data != null ? print(data) : print('wait');
    return Scaffold(
      body: Container(
        child: data != null ? Profile() : Loading(),
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

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          //Cover
          Container(
            height: x.height / 4.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/talentapp-dc5b9.appspot.com/o/avatars%2Fcover.jpg?alt=media&token=f0f704c8-71b9-493c-a4cf-d6ef5da57396'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              //Profile Picture
              Center(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(data['profile_picture_url']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(80.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //Info
              Text(
                data['name'],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data['bio'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'mafesh location fel db',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //Stats
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    StatItem(
                      count: data['post_count'].toString(),
                      label: 'Posts',
                    ),
                    GestureDetector(
                      child: StatItem(
                        count: data['follower_count'].toString(),
                        label: 'Followers',
                      ),
                      onTap: () {
                        print('followers');
                      },
                    ),
                    GestureDetector(
                      child: StatItem(
                        count: data['following_count'].toString(),
                        label: 'Following',
                      ),
                      onTap: () {
                        print('following');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //Feed
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    PostStub(),
                    PostStub(),
                    PostStub(),
                    PostStub(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String count;
  final String label;

  StatItem({this.count, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class PostStub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('go to post');
      },
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
