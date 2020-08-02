import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/Classes/User.dart';

User user;
Firestore fs = Firestore.instance;

class EditProfile extends StatefulWidget {
  EditProfile({@required this.uid});
  final String uid;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoaded = false;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  final globalkey = new GlobalKey<ScaffoldState>();

  getData() async {
    user = await fs.collection('users').document(widget.uid).get().then((value) => User.fromJson(value.data));
    name.text = user.name;
    bio.text = user.bio;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size; 
    return Scaffold(
      key: globalkey,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: isLoaded ? SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: x.height / 10,),
            Text('Name:'),
            SizedBox(height: x.height / 100,),
            TextField(
              onChanged: (text){name.value = name.value.copyWith(text: text);},
              textAlign: TextAlign.center,
              controller: name,
            ),
            SizedBox(height: x.height / 10,),
            Text('Bio:'),
            SizedBox(height: x.height / 100,),
            TextField(
              onChanged: (text){bio.value = bio.value.copyWith(text: text);},
              textAlign: TextAlign.center,
              controller: bio,
            ),
            SizedBox(height: x.height / 5,),
            RaisedButton(
              onPressed: () async {
                fs.collection('users').document(widget.uid).updateData({'name': name.value.text, 'bio': bio.value.text}).then((value){globalkey.currentState.showSnackBar(SnackBar(content: Text('Data Updated'),));}).catchError((e){globalkey.currentState.showSnackBar(SnackBar(content: Text('Failed'),));});
                print(name.value.text);
                print(bio.value.text);
              },
              child: Text('Save'),
              color: Colors.blue,
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}