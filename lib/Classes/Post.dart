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
  int likes;
  int createdAt;
  //List<Comment> comment;

  Post({
    this.title,
    this.description,
    this.category,
    this.userId,
    //this.userName,
    this.url,
    this.likes,
    this.createdAt,
    //this.comment,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    title: json['title'],
    description: json['description'],
    category: json['category'],
    userId: List<String>.from(json["user_id"].map((x) => x)),
    //userName: List<String>.from(json["user_name"].map((x) => x)),
    url: List<String>.from(json["url"].map((x) => x)),
    likes: json["likes"],
    createdAt: json["created_at"],
    //comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'title' : title,
    'description' : description,
    'category' : category,
    "user_id": List<dynamic>.from(userId.map((x) => x)),
    //"user_name": List<dynamic>.from(userName.map((x) => x)),
    "url": List<dynamic>.from(url.map((x) => x)),
    "likes": likes,
    "created_at": createdAt,
    //"comment": List<dynamic>.from(comment.map((x) => x.toJson())),
  };
}