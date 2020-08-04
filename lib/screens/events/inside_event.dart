import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/screens/events/selecting.dart';
import 'package:grad_project/screens/events/submission.dart';
import 'package:grad_project/screens/events/winner.dart';
import 'package:grad_project/utils/text_styles.dart';
import 'package:intl/intl.dart';


class InsideEvent extends StatefulWidget {
  String url,title,start,end,description,rules,id;
  bool begin , endng;
  InsideEvent({this.url,this.title,this.start,this.end,this.description,this.rules,this.id,this.begin,this.endng});

  @override
  _InsideEventState createState() => _InsideEventState();
}

class _InsideEventState extends State<InsideEvent> {
  String text=" ";
  DateTime now =DateTime.now();

  String getTime(String time) {
    String time1,time2;
    DateTime now = DateTime.parse(time);
    time1 = DateFormat.yMMMMd().format(now);
    time2 = DateFormat.jm().format(now);
    return time1 + " " +time2 ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
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
      body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[

                Card(
                  child: Image.network(widget.url),
                  elevation: 5,
                ),
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("from :${getTime(widget.start)}",style: TextStyle(fontSize: 13)),
                    Text("to: ${getTime(widget.end)}",style: TextStyle(fontSize: 13)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed:() {
                        setState(() {
                          text=widget.description;
                        });
                      },
                      textColor: Colors.white,
                       padding: const EdgeInsets.all(0.0),
                        child:  Container(
                          decoration: const BoxDecoration(
                          gradient: LinearGradient(
                          colors: <Color>[
                          Color(0xff4c997f),
                          Color(0xFF58b294),
                          Color(0xFF65cca9),
                          ],
                          ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child:
                          const Text('Description', style: TextStyle(fontSize: 20)),
                          ),


                    ),
                    SizedBox(width: 5,),
                    RaisedButton(
                        onPressed:() => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>Submission(id:widget.id,ending:widget.endng,finished: widget.end),),),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child:  Container(
                                  decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF65cca9),
                                    Color(0xFF58b294),
                                    Color(0xff4c997f),
                                  ],
                                  ),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  const Text('Submission', style: TextStyle(fontSize: 20)),
                                  ),
                    ),
                  ],
                ),

                Center(
                  child: Text(text,
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                  ),
                ),
               _bulidRow(context,widget.end),
              ],
            ),
          ),
    );

  }
  Widget _bulidRow(BuildContext context, String x)
  {
    DateTime finish= DateTime.parse(x);
    if(widget.begin==true)
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
              onPressed:() => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>Selecting(id:widget.id),),),
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child:
              const Text('Submit', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      );
    }

    else if(now.isAfter(finish)){

      return FlatButton.icon(
          onPressed: (){
            return showModalBottomSheet(
              context: context,
                builder: (BuildContext context){
                  return  Winner(id:widget.id);
                },
             // backgroundColor: Colors.grey

            );
          },
          icon:Icon(Icons.whatshot,color: Colors.red,size: 36,) ,
          label: Text("View the Winner",style: TextStyle(fontSize: 16),));
    }

    else
      return Center(
        child: Text(
          "Not Available now",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
  }
}
