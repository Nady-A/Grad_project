import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());


class User{
  String id;
  String name;
  String bio;
  String profilePictureUrl;
  int followingCount;
  int followerCount;
  int postCount;

  User({
    this.id,
    this.name,
    this.bio,
    this.profilePictureUrl,
    this.followingCount,
    this.followerCount,
    this.postCount,
  });


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    bio: json["bio"],
    profilePictureUrl: json["profile_picture_url"],
    followingCount: json["following_count"],
    followerCount: json["follower_count"],
    postCount: json["post_count"],);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bio": bio,
    "profile_picture_url": profilePictureUrl,
    "following_count": followingCount,
    "follower_count" : followerCount,
    "post_count": postCount,};
}