import 'package:flutter/material.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseUser currentUser;
Firestore fs = Firestore.instance;
Map<String, dynamic> data;
QuerySnapshot posts;
getData() async {
  currentUser = await FirebaseAuth.instance.currentUser();
  data = await fs.collection('users').document(currentUser.uid).get().then((x) {
    return x.data;
  });
  posts = await fs.collection('posts').where('user_id', arrayContains: currentUser.uid).getDocuments();
}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Post(),
                Post(),
                Post(),
                Post(),
              ],
            ) ),
      ),


    );
  }
}
class Post extends StatelessWidget {
  //Post({this.post});

  //final DocumentSnapshot post;
  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        return showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('TODO: POST PAGE'),
                // content: Text('go to post with id: ${post.documentID}'),
                actions: <Widget>[
                  FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('close')),
                ],
              );
            }
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 375,
              height: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage('https://i.gyazo.com/8ed3f03ef359007c5d8e3fda87e182b4.png'),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: x.height / 4.75,
              left: x.width / 15,
              child: Text(
                'title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              top: x.height / 5.25,
              right: x.width / 15,
              child: IconButton(
                onPressed: (){
                  return showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('TODO: LIKE'),
                          content: Text('add like functionality'),
                          actions: <Widget>[
                            FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('close')),
                          ],
                        );
                      }
                  );
                },
                icon: Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}