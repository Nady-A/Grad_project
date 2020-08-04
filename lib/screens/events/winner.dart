import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/screens/profile/my_profile.dart';
import 'package:grad_project/screens/profile/user_profile.dart';
import 'package:provider/provider.dart';
class Winner extends StatefulWidget {
  String id;
  Winner({this.id});
  @override
  _WinnerState createState() => _WinnerState();
}


class _WinnerState extends State<Winner> {
  bool _eventIsLoaded = false;
  var dat=[],show=[];
  int max=0;
  String postId,URL,myId;
  void initState() {
    super.initState();

    fetchPostAndChangeState();
  }

  void fetchPostAndChangeState() async {
    myId = await Provider.of<PostProvider>(context, listen: false).getMyId();
    try {
      Firestore _db = Firestore.instance;
      var firebaseData =await _db.collection("events").document(widget.id).collection("submissions").getDocuments();
      firebaseData.documents.forEach(
              (x) async{
            String url;
            await _db.collection('posts').document(x['post_id']).get().then((a){
              url = a.data['url'][0];
            });
            dat.add({
              "postId": x["post_id"],
              "rate": x["rating"],
              "url" : url
            });
          }
      );
      await Future.delayed(Duration(seconds: 1),() {
        setState(() {
          _eventIsLoaded = true;
        });
      });

    } catch (e) {
      print(e);
      print('error occured while fetching post');
    }
  }
  @override
  Widget build(BuildContext context) {
    for(int i=0 ; i<dat.length;i++)
      {
        if(dat[i]['rate']>max)
          {
            max=dat[i]['rate'];
            postId=dat[i]['postId'];
            URL=dat[i]['url'];
          }
      }
    if (_eventIsLoaded) {
      returning(postId);
      return Card(
        child:Column(
        children: <Widget>[
          SizedBox(height: 5,),
          Text("-{ The Winner }-",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.green),),
          SizedBox(height: 5,),
          Image.network(URL,height: 330,),
          Divider(),
          ListTile(

            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(show[0]["cover"]),
            ),
            title: Text(show[0]["name"],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0.0,10.0,0,0),
              child: Text("With  $max  likes",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
            ),
          ),

        ],
      ) ,
    );
    } else {
      return Center(child: CircularProgressIndicator(),);
    }
  }

  void returning(String x) async{
    Firestore _db = Firestore.instance;
    String user,cover,name;
    try
   {
     var firebaseData =await _db.collection("posts").document(x).get();
    user=firebaseData.data['user_id'][0];
    var fbd= await _db.collection("users").document(user).get();
    cover=fbd.data["cover_picture_url"];
    name = fbd.data["name"];
    show.add({
      "cover": cover,
      "name": name,
    });

   }catch(e){
      print(user);
    }

  }
}
