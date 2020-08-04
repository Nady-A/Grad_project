import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/Classes/Search.dart';
import 'package:grad_project/screens/NewSearch.dart';
import 'package:grad_project/Classes/AppDrawer.dart';
import 'package:grad_project/screens/profile/post_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _loadingDone;
  var posts = [];
  var userId;

  @override
  void initState() {
    super.initState();
    _loadingDone = false;
    fetchHomeAndChangeState();
  }

  void fetchHomeAndChangeState() async {
    Firestore _db = Firestore.instance;
    await FirebaseAuth.instance.currentUser().then((res) => userId = res.uid);
    var aggregateFetchedPosts = [];
    var following = await _db
        .collection('users')
        .document(userId)
        .collection('following')
        .getDocuments();
    for (var f in following.documents) {
      print(f.documentID);
      await _db
          .collection('posts')
          .where('user_id', arrayContains: f.documentID)
          .orderBy('created_at', descending: true)
          .limit(10)
          .getDocuments()
          .then((fetchedUserPosts) {
        for (var post in fetchedUserPosts.documents)
          aggregateFetchedPosts.add(post);
      });
    }
    posts = aggregateFetchedPosts;
    setState(() {
      _loadingDone = true;
    });
  }

  Widget buildHomePosts() {
    return posts.isEmpty
        ? Center(
            child: Text('You have no new posts'),
          )
        : Column(
            children: posts.map((post) {
              return Post(
                post: post,
                uid: userId,
              );
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Home",
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: () {
//              showSearch(context: context, delegate: DataSearch());
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewSearch()));
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _loadingDone = false;
            });
            fetchHomeAndChangeState();
          },
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Latest from creators you follow',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.homeHeading,
                  ),
                  !_loadingDone
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.all(15),
                          child: CircularProgressIndicator(),
                        ))
                      : buildHomePosts(),
//                  posts.isEmpty
//                      ? Center(
//                          child: Text('You have no new posts'),
//                        )
//                      : _loadingDone
//                          ? Column(
//                              children: posts.map((post) {
//                                return Post(
//                                  post: post,
//                                  uid: userId,
//                                );
//                              }).toList(),
//                            )
//                          : Center(
//                              child: Padding(
//                                padding: const EdgeInsets.all(15.0),
//                                child: CircularProgressIndicator(),
//                              ),
//                            )
                ],
              )),
        ),
      ),
    );
  }
}
