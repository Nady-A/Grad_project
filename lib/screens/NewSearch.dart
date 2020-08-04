import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/screens/profile/post_card.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:grad_project/screens/profile/my_profile.dart';
import 'package:grad_project/screens/profile/user_profile.dart';

class NewSearch extends StatefulWidget {
  @override
  _NewSearchState createState() => _NewSearchState();
}

class _NewSearchState extends State<NewSearch> {
  var userResults = [];
  var postResults = [];
  var qryController = TextEditingController();
  var myId;
  bool searching = false;
  String resTxt = '';

  search(String query) async {
    if (query.trim().isEmpty) {
      print('nothing');
      return;
    }
    setState(() {
      userResults = [];
      postResults = [];
      searching = true;
    });
    Firestore _db = Firestore.instance;
    myId =
        await FirebaseAuth.instance.currentUser().then((res) => myId = res.uid);
    await _db
        .collection('posts')
        .where('title', isEqualTo: query)
        .getDocuments()
        .then((posts) {
      for (var post in posts.documents) postResults.add(post);
    });

    await _db
        .collection('users')
        .where('name', isEqualTo: query)
        .getDocuments()
        .then((users) {
      for (var user in users.documents) userResults.add(user);
    });
    setState(() {
      if(postResults.isEmpty && userResults.isEmpty)resTxt = 'No results';
      searching = false;
    });
  }

  Widget _buildPostResults() {
    return postResults.isEmpty
        ? Container(
            height: 0,
            width: 0,
          )
        : Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              children: <Widget>[
                Text(
                  'Posts',
                  style: AppTextStyles.homeHeading,
                ),
                Column(
                  children: postResults
                      .map((post) => Post(
                            post: post,
                            uid: myId,
                          ))
                      .toList(),
                )
              ],
            ),
          );
  }

  Widget _buildUserResults() {
    return Container(
      child: userResults.isEmpty
          ? Container(
              height: 0,
              width: 0,
            )
          : Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                children: <Widget>[
                  Text(
                    'Users',
                    style: AppTextStyles.homeHeading,
                  ),
                  Column(
                    children: userResults.map((user) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Image.network(user['profile_picture_url']),
                        ),
                        title: Text(user['name']),
                        onTap: () {
                          if (user['id'] == myId) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfile()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                          uid: user['id'],
                                        )));
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: qryController,
          autofocus: true,
          decoration:
              InputDecoration(hintText: 'Search', border: InputBorder.none),
          onEditingComplete: () {
            print('editing complete');
            FocusScope.of(context).requestFocus(new FocusNode());
            search(qryController.value.text);
          },
        ),
      ),
      body: Container(
        child: searching
            ? Center(child: CircularProgressIndicator())
            : postResults.isEmpty && userResults.isEmpty
                ? Center(
                    child: Text(
                      resTxt,
                      style: AppTextStyles.homeHeading,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildUserResults(),
                        _buildPostResults(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
