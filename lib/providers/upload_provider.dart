import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/Classes/Post.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Uploader extends ChangeNotifier {
  List<List<String>> _userSearchResult = [];
  var _db = Firestore.instance;

  List<List<String>> get getSearchResults => _userSearchResult;

  searchForUser(String username) async {
    clearSearch();
    var res = await _db
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();

    for (var x in res.documents) {
      print(x.data['name']);
      List<String> user = [
        x.data['name'],
        x.data['id'],
        x.data['profile_picture_url']
      ];
      _userSearchResult.add(user);
    }

    notifyListeners();
  }

  void clearSearch() {
    _userSearchResult = [];
  }

  Future<String> uploadPost(
      {@required List<File> files,
      @required String category,
      @required List<List<String>> coAuthorData,
      @required List<String> tags,
      @required String postTitle,
      @required postDescription}) async {
    StorageReference storageReference;
    StorageUploadTask storageUploadTask;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    List<String> uploadUrls = [];
    List<String> userIds = [];
    try {
      for (File f in files) {
        print(1);
        storageReference = FirebaseStorage.instance.ref().child('/files').child(
            DateTime.now().millisecondsSinceEpoch.toString() +
                basename(f.path));
        storageUploadTask = storageReference.putFile(f);
        print(2);
        var url =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();
        print(3);
        uploadUrls.add(url.toString());
      }

      print(4);
      var user = await firebaseAuth.currentUser();
      var uId = user.uid;
      userIds.add(uId);

      coAuthorData.forEach((u) => userIds.add(u[1]));

      Post p = Post(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        likes: 0,
        views: 0,
        url: uploadUrls,
        tags: tags,
        title: postTitle,
        description: postDescription,
        category: category,
        userId: userIds,
      );

      await _db.collection('posts').add(p.toJson());

      return 'Upload successful';
    } catch (e) {
      print(e);
      return 'error occured';
    }
  }
}
