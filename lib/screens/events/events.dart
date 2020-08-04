import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/providers/post_provider.dart';
import 'package:grad_project/screens/events/card_view.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:intl/intl.dart';

class Events extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Events',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: Eventss(),

    );
  }
}

class Eventss extends StatefulWidget {
  @override
  _EventssState createState() => _EventssState();
}

class _EventssState extends State<Eventss> {
  bool _eventIsLoaded = false;
  var dat=[];
  PostProvider pp;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DateTime day =DateTime.now();
  //DateTime test = DateTime.utc(day.year,day.day,day.hour,day.minute,day.second);
  bool first,last;
  void initState() {
    super.initState();
    fetchPostAndChangeState();
  }

  getMyId() async {
    var user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  void fetchPostAndChangeState() async {
    try {
      Firestore _db = Firestore.instance;
      var firebaseData =await _db.collection("events").getDocuments();
      firebaseData.documents.forEach(
              (x) {
                first = begain(x["startDate"]);
                last=ending(x["endDate"]);
            dat.add({
              "url": x["coverPhotoUrl"],
              "description": x["description"],
              "title": x["title"],
              "rules": x["rules"],
              "start": x["startDate"],
              "end": x["endDate"],
              "began":first,
              "endng":last,
              "id": x.documentID,
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
    print("this day is ${day}");
    return _eventIsLoaded? RefreshIndicator(
      child: ListView.builder(
          itemCount: dat.length,
        itemBuilder: (BuildContext context, int i)
        {
          return CardView(
              url: dat[i]['url'],
              title: dat[i]['title'],
              start: dat[i]['start'],
              end: dat[i]['end'],
              description: dat[i]['description'],
              rules: dat[i]['rules'],
              id: dat[i]['id'],
              begin: dat[i]['began'],
              endng: dat[i]['endng'],
          );
        },

      ),
      onRefresh: updateTime,
    ):Center(child: CircularProgressIndicator(),);
  }

//  String getTime(String time) {
//      String time1,time2;
//      DateTime now = DateTime.parse(time);
//      time1 = DateFormat.yMMMMd().format(now);
//      time2 = DateFormat.jm().format(now);
//      return time1 + " " +time2 ;
//  }

  bool begain(String time) {
       var now = DateTime.parse(time);
    var after7days = now.add(new Duration(days: 7));
    if(day.isAfter(now)&& day.isBefore(after7days))
      return true;
    else
    return false;

  }
  bool ending(String time) {
    var now = DateTime.parse(time);
    var from2week = now.subtract(new Duration(days: 23));
    if(day.isAfter(from2week)&& day.isBefore(now))
      return true;
    else
    return false;

  }

  Future<Null> updateTime() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      day=DateTime.now();
    });
    return Null;
  }
}

