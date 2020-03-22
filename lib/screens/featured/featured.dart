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


class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: !isSearching ?
            Text(
              "Discover",
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
                    color: Colors.blueAccent),
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
                      child: Text("Music"),
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
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(15.0) ,
                      child: Text("Best of Last Week",
                        style: AppTextStyles.appBarTitle,
                      ),
                    ),
                    Post(),
                    Post(),
                  ],
                )
              ),
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0) ,
                        child: Text("Music",
                          style: AppTextStyles.appBarTitle,
                        ),
                      ),
                      Post(),
                      Post(),
                    ],
                  )
               ),
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0) ,
                        child: Text("Photography",
                          style: AppTextStyles.appBarTitle,
                        ),
                      ),
                      Post(),
                      Post(),
                    ],
                  )
              ),
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0) ,
                        child: Text("Graphic Design",
                          style: AppTextStyles.appBarTitle,
                        ),
                      ),
                      Post(),
                      Post(),
                    ],
                  )
              ),
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0) ,
                        child: Text("Drawing",
                          style: AppTextStyles.appBarTitle,
                        ),
                      ),
                      Post(),
                      Post(),
                    ],
                  )
              ),
              Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0) ,
                        child: Text("Crafts",
                          style: AppTextStyles.appBarTitle,
                        ),
                      ),
                      Post(),
                      Post(),
                    ],
                  )
              ),
            ],
          ),
        )
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
class CategoryButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      body: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),),
        padding: EdgeInsets.all(1.0),
        onPressed: () {},
        child: Image(
          image: NetworkImage('https://i.gyazo.com/8ed3f03ef359007c5d8e3fda87e182b4.png'),
          //https://www.pngarts.com/files/3/Button-PNG-Picture.png
          fit: BoxFit.fill,
        ),
      ),
    ); //Scaffold
  }
}









//                        FlatButton(
//                          shape: new RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(18.0),),
//                          padding: EdgeInsets.all(1.0),
//                          onPressed: () {},
//                          child: Image(
//                            image: NetworkImage('https://i.gyazo.com/8ed3f03ef359007c5d8e3fda87e182b4.png'),
//                            fit: BoxFit.fill,
//                          ),
//                        ),
//                      ],
//                    )  ),
//              ),