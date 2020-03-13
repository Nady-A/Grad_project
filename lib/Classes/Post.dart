import 'dart:convert';
import 'package:grad_project/Classes/Comment.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  String title;
  String description;
  String category;
  List<String> userId;
  //List<String> userName;
  List<String> url;
  List<String> tags;
  int likes;
  int views;
  int createdAt;
  String postId;
  //List<Comment> comment;
  //Attributes related to drawing post on screen
  //Come from firebase operations not json
  bool inLikes;
  bool inFavs;
  List<List<String>> creatorsAvatarsAndIds = [];
  List<bool> creatorsAreFollowed = [];

  Post({
    this.title,
    this.description,
    this.category,
    this.userId,
    this.tags,
    //this.userName,
    this.url,
    this.likes,
    this.views,
    this.createdAt,
    //this.comment,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        title: json['title'],
        description: json['description'],
        category: json['category'],
        userId: List<String>.from(json["user_id"].map((x) => x)),
        tags: List<String>.from(json["tags"].map((x) => x)),
        //userName: List<String>.from(json["user_name"].map((x) => x)),
        url: List<String>.from(json["url"].map((x) => x)),
        likes: json["likes"],
        views: json["views"],
        createdAt: json["created_at"],
        //comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'category': category,
        "user_id": List<dynamic>.from(userId.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        //"user_name": List<dynamic>.from(userName.map((x) => x)),
        "url": List<dynamic>.from(url.map((x) => x)),
        "likes": likes,
        "views": views,
        "created_at": createdAt,
        //"comment": List<dynamic>.from(comment.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return "title $title \n description $description \n category $category \n ids ${userId.toString()} \n views $views \n authordata $creatorsAvatarsAndIds \n inlikes $inLikes \n infavs $inFavs \n";
  }
}
