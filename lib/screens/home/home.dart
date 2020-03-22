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


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: !isSearching ?
        Text(
          "Home",
          style: AppTextStyles.appBarTitle,)
            :TextField(
          decoration: InputDecoration(
              icon: Icon(Icons.search),
              hintText: "search"),),
        centerTitle: true,
        leading:
        IconButton(
          icon: Icon(Icons.format_list_bulleted),
          color: Colors.black,
          onPressed: (){},
        ),
        actions: <Widget>[
          isSearching?
          IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.black,
            onPressed: (){
              setState(() {
                this.isSearching = !this.isSearching;
              });
            },
          ):
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: (){
              setState(() {
                this.isSearching = !this.isSearching;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.black,
            onPressed: (){},
          )
        ],
      ),

      body: Container(
        margin: EdgeInsets.all(15.0) ,
        child: Center(
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
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: x.height / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage("https://i.gyazo.com/8ed3f03ef359007c5d8e3fda87e182b4.png"),
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
                  Icons.favorite_border,
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