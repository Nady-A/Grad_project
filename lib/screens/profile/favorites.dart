import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/screens/profile/post_card.dart';

Firestore fs = Firestore.instance;
QuerySnapshot favIDs;
List<DocumentSnapshot> posts;

class Favorites extends StatefulWidget {
  Favorites({@required this.uid});
  final String uid;
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isLoaded = false;

  getData() async {
    favIDs = await fs.collection('users').document(widget.uid).collection('favs').getDocuments();
    List tmp1 = [];
    for(int i=0; i<favIDs.documents.length; i++){
      tmp1.add(favIDs.documents[i].documentID.toString());
    }
    posts = await fs.collection('posts').getDocuments().then((x) => x.documents.where((element) => tmp1.contains(element.documentID)).toList());

    print(posts);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorites"),
      ),
      body: isLoaded ? posts.length==0 ? Center(child: Text('You don\'t have any favorited posts.')) : ListView.builder(
        itemBuilder: (conetxt, index) => Post(post: posts[index], uid: widget.uid,),
        itemCount: posts.length,
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}