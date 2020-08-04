import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/Classes/Search.dart';
import 'package:grad_project/screens/NewSearch.dart';
import 'package:grad_project/Classes/AppDrawer.dart';
import 'package:grad_project/screens/profile/post_card.dart';

class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  static DateTime today = new DateTime.now();
  DateTime lastWeek = today.subtract(new Duration(days: 7));

  bool _loadingDone = false;
  var postsFeatured = [];
  var postsPhotography = [];
  var postsGraphicDesign = [];
  var postsDrawing = [];
  var postsCrafts = [];
  var userId;

  @override
  void initState() {
    super.initState();
    fetchHomeAndChangeState();
  }

  void fetchHomeAndChangeState() async {
    Firestore _db = Firestore.instance;
    await FirebaseAuth.instance.currentUser().then((res) => userId = res.uid);
    var aggregateFetchedFeaturedPosts = [];
    var aggregateFetchedPhotographyPosts = [];
    var aggregateFetchedGraphicDesignPosts = [];
    var aggregateFetchedDrawingPosts = [];
    var aggregateFetchedCraftsPosts = [];

    aggregateFetchedFeaturedPosts = await _db
        .collection('posts')
        .where('likes', isGreaterThan: 3)
        .getDocuments()
        .then((x) => x.documents
            .where((element) =>
                element.data['created_at'] > lastWeek.millisecondsSinceEpoch)
            .toList());
    var photograph = await _db
        .collection('posts')
        .where('category', isEqualTo: 'Photography')
        .orderBy('likes', descending: true)
        .limit(10)
        .getDocuments()
        .then((fetchedUserPosts) {
      for (var postP in fetchedUserPosts.documents)
        aggregateFetchedPhotographyPosts.add(postP);
    });
    var graphicDesign = await _db
        .collection('posts')
        .where('category', isEqualTo: 'Graphic Design')
        .orderBy('likes', descending: true)
        .limit(10)
        .getDocuments()
        .then((fetchedUserPosts) {
      for (var post in fetchedUserPosts.documents)
        aggregateFetchedGraphicDesignPosts.add(post);
    });
    var Drawing = await _db
        .collection('posts')
        .where('category', isEqualTo: 'Drawing')
        .orderBy('likes', descending: true)
        .limit(10)
        .getDocuments()
        .then((fetchedUserPosts) {
      for (var post in fetchedUserPosts.documents)
        aggregateFetchedDrawingPosts.add(post);
    });
    var crafts = await _db
        .collection('posts')
        .where('category', isEqualTo: 'Crafts')
        .orderBy('likes', descending: true)
        .limit(10)
        .getDocuments()
        .then((fetchedUserPosts) {
      for (var post in fetchedUserPosts.documents)
        aggregateFetchedCraftsPosts.add(post);
    });
    postsFeatured = aggregateFetchedFeaturedPosts;
    postsPhotography = aggregateFetchedPhotographyPosts;
    postsGraphicDesign = aggregateFetchedGraphicDesignPosts;
    postsDrawing = aggregateFetchedDrawingPosts;
    postsCrafts = aggregateFetchedCraftsPosts;
    setState(() {
      _loadingDone = true;
    });
  }

  Widget buildTabView(List posts, String categoryName) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadingDone = false;
        });
        fetchHomeAndChangeState();
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15.0),
              child: Text(
                categoryName,
                textAlign: TextAlign.start,
                style: AppTextStyles.homeHeading,
              ),
            ),
            posts.isEmpty
                ? Center(
                    child: Text('No posts Yet. But stay tuned!!'),
                  )
                : _loadingDone
                    ? Column(
                        children: posts.map((post) {
                          return Post(
                            post: post,
                            uid: userId,
                          );
                        }).toList(),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: new AppDrawer(),
          appBar: AppBar(
            title: Text(
              "Discover",
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
//                  showSearch(context: context, delegate: DataSearch());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewSearch()));
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [Colors.blueAccent, Colors.purpleAccent]),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Featured"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Photography"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Graphic Design"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Drawing"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Crafts"),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: <Widget>[
              buildTabView(postsFeatured, 'Best of Last Week'),
              buildTabView(postsPhotography, 'Photography'),
              buildTabView(postsGraphicDesign, 'Graphic Design'),
              buildTabView(postsDrawing, 'Drawing'),
              buildTabView(postsCrafts, 'Crafts'),
            ],
          ),
        ));
  }
}
