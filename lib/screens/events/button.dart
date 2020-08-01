import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:provider/provider.dart';

class Button extends StatefulWidget {
  int rate;
  String id,doc;
  Button({this.rate,this.id,this.doc});
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool colored=false;
  Color c = Colors.grey;
  IconData i =Icons.favorite_border;
  Firestore _db = Firestore.instance;
  bool _checkIsdone = false;
  CollectionReference favRef;
  String myId;

  @override
  void initState() {
    CheckLike();
    super.initState();
  }
  void CheckLike() async {
    myId = await Provider.of<PostProvider>(context, listen: false).getMyId();
     favRef =
    _db.collection('events').document(widget.id).collection('submissions').document(widget.doc).collection("people_who_liked");
    await favRef.document(myId).get().then((result) {
      if (result.exists) {
        colored = true;
        i=Icons.favorite;
        c=Colors.red;
      } else {
        colored = false;
      }
    });
    setState(() {
      _checkIsdone = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return _checkIsdone? FlatButton.icon(
        onPressed: ()async{
      if(!colored){
        await _db.collection('events').document(widget.id).collection("submissions").document(widget.doc).updateData({'rating' : FieldValue.increment(1)});
        await favRef.document(myId).setData({'data' : '1'});
        setState(()  {
          widget.rate++;
          colored=!colored;
          i=Icons.favorite;
          c=Colors.red;
        });

      }
      else{
        await _db.collection('events').document(widget.id).collection("submissions").document(widget.doc).updateData({'rating' : FieldValue.increment(-1)});
        await favRef.document(myId).delete();
        setState(() {
          widget.rate--;
          colored=!colored;
          c=Colors.grey;
          i=Icons.favorite_border;
        });
      }
      },
      icon: Icon(
        i,
        color: c,
        size: 28,
      ),
      label: Text("${widget.rate}"),
    ):Center(child: CircularProgressIndicator());
  }
}
