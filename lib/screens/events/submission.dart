import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/screens/events/button.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:provider/provider.dart';

class Submission extends StatefulWidget {
  String id;
  bool ending;
  Submission({this.id,this.ending});

  @override
  _SubmissionState createState() => _SubmissionState();
}

class _SubmissionState extends State<Submission> {
  bool _eventIsLoaded = false;
  var dat=[];
  String  myProfilePic,myUserName,myId;

  void initState() {
    super.initState();

    fetchPostAndChangeState();
  }

  void fetchPostAndChangeState() async {
     myId = await Provider.of<PostProvider>(context, listen: false).getMyId();
     myProfilePic = await Provider.of<PostProvider>(context, listen: false).getMyProfilePicture();
     myUserName = await Provider.of<PostProvider>(context, listen: false).getMyUserName();
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
              "id": x.documentID,
              "url": url,
              // "doc": x.documentID,
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Submission',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),

             body:_eventIsLoaded? ListView.builder(
                 itemCount: dat.length,
                 itemBuilder: (BuildContext context, int index)
                 {
                   return Column(
                     children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 5.0),
                         child:
                         Card(
                           child:Column(
                               children: <Widget>[
                                 ListTile(
                                   title: Text(myUserName),
                                   leading: CircleAvatar(
                                     backgroundImage: NetworkImage(myProfilePic),
                                     ),
                                   onTap: () async{
                                     FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                     var user = await _firebaseAuth.currentUser();
                                     print("${user.uid}  +  ${myId}" );

                                   },

                                   ),
                                 Divider(),
                                 Image.network(
                                   dat[index]["url"],
                                   // height: 250,
                                 ),
                               ]),
                           elevation:5,
                         ),
                       ),
                       _bulidButton(index),
                       SizedBox(height: 5,),
                     ],
                   );

                 },
             ):Center(child: CircularProgressIndicator(),
             ),
    );


  }
Widget _bulidButton(int index)
{
  if(widget.ending==true)
      return Button(rate: dat[index]['rate'], id: widget.id, doc:dat[index]['id']);
  else
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "Not Available now",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
}

}
