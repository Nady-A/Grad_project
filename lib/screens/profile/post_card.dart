import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/screens/post/post.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/providers/post_provider.dart';


Firestore fs = Firestore.instance;

class Post extends StatefulWidget {
  Post({@required this.post, @required this.uid});

  final DocumentSnapshot post;
  final String uid;


  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  bool isLiked;
  var ref;

@override
  void initState() {
    super.initState();
    checkIfLiked();

  }

  checkIfLiked() async {
    ref  = fs.collection('users').document(widget.uid).collection('likes');
    await ref.document(widget.post.documentID).get().then((x){
      if(mounted && x.exists){
        setState(() {
          isLiked = true;
        });
      }
      else if(mounted && !x.exists){
        setState(() {
          isLiked = false;
        });
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
  Size x = MediaQuery.of(context).size;
    return isLiked != null ? GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(widget.post.documentID)));
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
                    image: NetworkImage(widget.post['url'][0]),
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
                widget.post['title'],
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
                onPressed: () async{
                  if(isLiked){
                    await Provider.of<PostProvider>(context, listen: false).deleteFromLikes(widget.post.documentID);
                    print('dislike');
                    setState(() {
                      isLiked = !isLiked;
                    });
                  }
                  else{
                    await Provider.of<PostProvider>(context, listen: false).addToLikes(widget.post.documentID);
                    print('like');
                    setState(() {
                      isLiked = !isLiked;
                    });
                  }
                  },
                icon: Icon(
                  isLiked? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    ) : CircularProgressIndicator();
  }
}