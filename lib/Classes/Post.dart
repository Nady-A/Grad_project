import 'dart:convert';
import 'package:grad_project/Classes/Comment.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  String userId;
  String userName;
  List<String> url;
  int likes;
  int createdAt;
  List<Comment> comment;

  Post({
    this.userId,
    this.userName,
    this.url,
    this.likes,
    this.createdAt,
    this.comment,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    userId: json["user_id"],
    userName: json["user_name"],
    url: List<String>.from(json["url"].map((x) => x)),
    likes: json["likes"],
    createdAt: json["created_at"],
    comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "url": List<dynamic>.from(url.map((x) => x)),
    "likes": likes,
    "created_at": createdAt,
    "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
  };
}