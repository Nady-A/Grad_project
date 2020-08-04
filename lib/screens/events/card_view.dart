import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/screens/events/inside_event.dart';
import 'package:grad_project/screens/events/submission.dart';
import 'package:intl/intl.dart';
class CardView extends StatelessWidget {
  String url,title,start,end,description,rules,id;
  bool begin , endng;
  CardView({this.url,this.title,this.start,this.end,this.description,this.rules,this.id,this.begin,this.endng});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>InsideEvent(url: url,title: title,start: start,end: end,description: description,rules: rules,id: id,begin:begin,endng: endng),),);
        },
        child: Column(
          children: <Widget>[
            Image.network(
              url,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(height: 3,),
            Center(child: Text(title,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
            SizedBox(height: 3,),

                Text("from : ${getTime(start)}",style: TextStyle(fontSize: 13),),
                Text("to : ${getTime(end)}",style: TextStyle(fontSize: 13),),


            SizedBox(height: 5,),
          ],
        ),
      ),
      elevation: 5,
    );;
  }
  String getTime(String time) {
    String time1,time2;
    DateTime now = DateTime.parse(time);
    time1 = DateFormat.yMMMMd().format(now);
    time2 = DateFormat.jm().format(now);
    return time1 + " " +time2 ;
  }

}
