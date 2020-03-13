import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/Classes/Post.dart';
import 'package:grad_project/Classes/Comment.dart';

class PostProvider extends ChangeNotifier {
  Firestore _db = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Post _post;

  ///Getting post and all related information
  getPost(String postId) async {
    print('FETCHING POST FROM FIREBASE');
    Post p;
    print(postId);
    await _incrementView(postId);
    await _getPostBody(postId);
    await _getCreatorsInfo();
    await _getFollowStatus();
    await _getLikeAndFavStatus(postId);
    p = _post;
    return p;
  }

  _getPostBody(String postId) async {
    await _db.collection('posts').document(postId).get().then((x) {
      _post = Post.fromJson(x.data);
      _post.postId = x.documentID;
    });
  }

  _getCreatorsInfo() async {
    var userIds = _post.userId;

    for (var id in userIds) {
      await _db.collection('users').document(id).get().then((x) {
        _post.creatorsAvatarsAndIds
            .add([x['name'], id, x['profile_picture_url']]);
      });
    }
  }

  _getLikeAndFavStatus(String postId) async {
    var user = await _firebaseAuth.currentUser();

    await _db
        .collection('users')
        .document(user.uid)
        .collection('likes')
        .where(
      "post_id",
      isEqualTo: postId,
    )
        .getDocuments()
        .then((x) {
      if (x.documents.isEmpty) {
        _post.inLikes = false;
      } else {
        _post.inLikes = true;
      }
    });

    await _db
        .collection('users')
        .document(user.uid)
        .collection('favs')
        .where(
      "post_id",
      isEqualTo: postId,
    )
        .getDocuments()
        .then((x) {
      if (x.documents.isEmpty) {
        _post.inFavs = false;
      } else {
        _post.inFavs = true;
      }
    });
  }

  _getFollowStatus() async {
    var userIds = _post.userId;
    var myData = await _firebaseAuth.currentUser();
    var myId = myData.uid;

    for (var id in userIds) {
      if (id == myId) {
        print('CANNOT FOLLOW YOURSELF');
        _post.creatorsAreFollowed.add(false);
        continue;
      }
      await _db.collection('users').document(myId).collection('following').document(id).get().then((result) {
        if (result.exists) {
          print('USER $id IS FOLLOWED');
          _post.creatorsAreFollowed.add(true);
        } else {
          print('USER $id IS NOT FOLLOWED');
          _post.creatorsAreFollowed.add(false);
        }
      });
    }
  }

  _incrementView(String postId) async {
    await _db.collection('posts').document(postId).updateData({'views': FieldValue.increment(1)});
  }

  ///More work from creators
  ///Takes creators ids to fetch posts from their collections
  getMoreFromCreator(List<String> ids, String postId) async {
    List<List<String>> posts = [];
    for (var id in ids) {
      await _db.collection('posts').where('user_id', arrayContains: id).limit(3).getDocuments().then((result) {
        for (var doc in result.documents) {
          if (doc.documentID == postId) continue;
          posts.add([doc.documentID, doc.data['url'][0], doc.data['category']]);
        }
      });
    }
    return posts;
  }

  ///Similar posts in sent category
  ///Takes post id to avoid duplication
  getSimilarPosts(String category, String postId) async {
    List<List<String>> posts = [];
    await _db
        .collection('posts')
        .where('category', isEqualTo: category)
        .limit(10)
        .getDocuments()
        .then((results) {
      for (var doc in results.documents) {
        if (doc.documentID == postId) {
          continue;
        }
        posts.add([doc.documentID, doc.data['url'][0], doc.data['category']]);
      }
    });
    return posts;
  }

  ///Comment functions

  ///Orders fetched comments by new
  ///For each comment gets username and profile pic for commenter from users collection
  getComments(String postId) async {
    List<Comment> comments = [];

    var fetchedComments = await _db
        .collection('posts')
        .document(postId)
        .collection('comments')
        .orderBy('created_at', descending: true)
        .getDocuments();
    for (var doc in fetchedComments.documents) {
      Comment c = Comment.fromJson(doc.data);
      c.commentId = doc.documentID;
      await _db.collection('users').document(doc['user_id']).get().then((user) {
        c.profilePic = user.data['profile_picture_url'];
        c.userName = user.data['name'];
      });
      comments.add(c);
    }
    return comments;
  }

  ///Adds comment with epoch timestamp
  ///Timestamp is used for sorting on retrieval only
  addComment(String txt, String postId) async {
    var user = await _firebaseAuth.currentUser();
    Comment c = Comment(commentText: txt, userId: user.uid, createdAt: DateTime.now().millisecondsSinceEpoch);

    var addedCommentRef = await _db
        .collection('posts')
        .document(postId)
        .collection('comments')
        .add(c.toJson());

    return addedCommentRef.documentID;
  }

  deleteComment(String postId, String commentId) async {
    await _db.collection('posts').document(postId).collection('comments').document(commentId).delete();
  }

  ///Current user information
  getMyProfilePicture() async {
    String profilePicUrl;
    var user = await _firebaseAuth.currentUser();
    await _db.collection('users').document(user.uid).get().then((val) {
      print(val.data);
      profilePicUrl = val.data['profile_picture_url'];
    });
    return profilePicUrl;
  }

  getMyId() async {
    var user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  getMyUserName() async {
    String userName;
    var user = await _firebaseAuth.currentUser();
    await _db.collection('users').document(user.uid).get().then((val) {
      userName = val.data['name'];
    });
    return userName;
  }


  ///Likes
  Future<String> addToLikes(String postId) async {
    try {
      var user = await _firebaseAuth.currentUser();
      //Add post to my likes collection
      await _db
          .collection('users')
          .document(user.uid)
          .collection('likes')
          .add({'post_id': postId});
      //Increment post likes by 1
      await _db
          .collection('posts')
          .document(postId)
          .updateData({"likes": FieldValue.increment(1)});
      return 'Added to likes';
    } catch (e) {
      return 'An error occured';
    }
  }

  Future<String> deleteFromLikes(String postId) async {
    try {
      var user = await _firebaseAuth.currentUser();
      //Search for post id then delete document containing it
      await _db
          .collection('users')
          .document(user.uid)
          .collection('likes')
          .where("post_id", isEqualTo: postId)
          .getDocuments()
          .then((x) {
        x.documents[0].reference.delete();
      });
      await _db.collection('posts').document(postId).updateData({"likes": FieldValue.increment(-1)});
      return 'Removed from likes';
    } catch (e) {
      return 'An error occured';
    }
  }


  ///Favourites

  Future<String> addToFavs(String postId) async {
    try {
      var user = await _firebaseAuth.currentUser();
      //Add post to my favourites collection
      await _db
          .collection('users')
          .document(user.uid)
          .collection('favs')
          .add({'post_id': postId});
      return 'Added to favourites';
    } catch (e) {
      return 'An error occured';
    }
  }



  Future<String> deleteFromFavs(String postId) async {
    try {
      var user = await _firebaseAuth.currentUser();
      await _db
          .collection('users')
          .document(user.uid)
          .collection('favs')
          .where("post_id", isEqualTo: postId)
          .getDocuments()
          .then((x) {
        x.documents[0].reference.delete();
      });
      return 'Removed from favourites';
    } catch (e) {
      return 'An error occured';
    }
  }

  ///Follow
  ///
  /// Uses key instead of entire document
  followUser(String userId) async {
    var user = await _firebaseAuth.currentUser();
    String myId = user.uid;

    CollectionReference myFollowingRef =
        _db.collection('users').document(myId).collection('following');
    CollectionReference userFollowerRef =
        _db.collection('users').document(userId).collection('my_followers');
    //Increment my following count by 1
    await _db
        .collection('users')
        .document(myId)
        .updateData({'following_count': FieldValue.increment(1)});
    //Increment users followers count by 1
    await _db
        .collection('users')
        .document(userId)
        .updateData({'follower_count': FieldValue.increment(1)});

    //Add user to my following list
    await myFollowingRef
        .document(userId)
        .setData({'place_holder': 'place_holder'});

    //Add me to user follower list
    await userFollowerRef
        .document(myId)
        .setData({'place_holder': 'place_holder'});
  }

  unFollowUser(String userId) async {
    var user = await _firebaseAuth.currentUser();
    String myId = user.uid;

    CollectionReference myFollowingRef =
        _db.collection('users').document(myId).collection('following');
    CollectionReference userFollowerRef =
        _db.collection('users').document(userId).collection('my_followers');

    await _db
        .collection('users')
        .document(myId)
        .updateData({'following_count': FieldValue.increment(-1)});

    await _db
        .collection('users')
        .document(userId)
        .updateData({'follower_count': FieldValue.increment(-1)});

    //Delete user from my following list
    await myFollowingRef.document(userId).delete();

    //Delete my entry from his followers list
    await userFollowerRef.document(myId).delete();
  }

  Post get post => _post;
}
