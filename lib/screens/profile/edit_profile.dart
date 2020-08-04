import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/Classes/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

User user;
Firestore fs = Firestore.instance;
dynamic avatarPicture;
File file;

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
      avatarPicture = NetworkImage(user.profilePictureUrl);
      isLoaded = true;
    });
  }

  Future<bool> clearFile() async {
    if(file != null){
      file = null;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size x = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: clearFile,
      child: Scaffold(
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
              SizedBox(height: x.height / 10,),
              Text('Profile Picture:'),
              SizedBox(height: x.height / 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(backgroundImage: avatarPicture, radius: 40,),
                  RaisedButton(
                    onPressed: () async {
                      file = await FilePicker.getFile(type: FileType.image);
                      setState(() {
                        file != null? avatarPicture = FileImage(file): print('hhh');
                      });
                    },
                    child: Text('Choose Image'),
                    ),
                ],
              ),
              SizedBox(height: x.height / 10,),
              RaisedButton(
                onPressed: () async {
                  if(file == null){
                    fs.collection('users').document(widget.uid).updateData({'name': name.value.text, 'bio': bio.value.text}).then((value){globalkey.currentState.showSnackBar(SnackBar(content: Text('Data Updated'),));}).catchError((e){globalkey.currentState.showSnackBar(SnackBar(content: Text('Failed'),));});
                  }
                  else{
                    StorageReference st = FirebaseStorage.instance.ref().child('/avatars').child(
                      user.id,
                    );
                    StorageUploadTask sut = st.putFile(file);
                    var newUrl = await (await sut.onComplete).ref.getDownloadURL();
                    fs.collection('users').document(widget.uid).updateData({'name': name.value.text, 'bio': bio.value.text, 'profile_picture_url': newUrl.toString()}).then((value){globalkey.currentState.showSnackBar(SnackBar(content: Text('Data Updated'),));}).catchError((e){globalkey.currentState.showSnackBar(SnackBar(content: Text('Failed'),));});
                  }
                },
                child: Text('Save'),
                color: Colors.blue,
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}