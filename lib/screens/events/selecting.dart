import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:provider/provider.dart';

class Selecting extends StatefulWidget {
  String id;
  Selecting({this.id});
  @override
  _SelectingState createState() => _SelectingState();
}

class _SelectingState extends State<Selecting> {
  Firestore _db = Firestore.instance;
  CollectionReference favRef;
  bool _eventIsLoaded = false;
  var dat = [];
  String myId;

  @override
  void initState() {
    super.initState();
    fetchPostAndChangeState();
  }

  void fetchPostAndChangeState() async {
    try {
      myId = await Provider.of<PostProvider>(context, listen: false).getMyId();
      Firestore _db = Firestore.instance;
      var firebaseData = await _db.collection("posts").where(
          "user_id", arrayContains: myId).getDocuments();
      firebaseData.documents.forEach(
              (x) {
            dat.add({
              "post_id": x.documentID,
              "url": x["url"][0]
            });
          }

      );
      await Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _eventIsLoaded = true;
        });
      });
    }
    catch (e) {
      print(e);
      print('error occured while fetching post');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an item',
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
      body: _eventIsLoaded ? ListView.builder(
          itemCount: dat.length,
          itemBuilder: (BuildContext context, int index)
        {
          return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 5.0),
                child:  Card(
                  child: InkWell(
                    onTap: ()async{
                      var idd=dat[index]["post_id"];
                      favRef =  _db.collection('events').document(widget.id).collection("submissions");
                      await favRef.document(idd).get().then((result) {
                        if(result.exists){
                          Scaffold.of(context).showSnackBar( SnackBar(
                            content: Text('Item is selected before'),
                          ),);
                        }
                        else
                        {  _db.collection('events').document(widget.id).collection("submissions").document(idd).setData({'post_id' : idd,'rating' : 0});
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item Added successfully'),
                          ),
                        );}
                      });


                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(dat[index]["url"],),

                      ],
                    ),
                  ),
                ),
              );
        }
      ) : Center(child: CircularProgressIndicator(),
      ),
    );
  }
}
