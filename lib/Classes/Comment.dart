class Comment {
  String commentId;
  String commentText;
  String userId;
  //Not from json
  String userName;
  String profilePic;
  int createdAt;

  Comment({
    //this.commentId,
    this.commentText,
    this.userId,
    this.createdAt,
    //this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    //commentId: json["comment_id"],
    commentText: json["comment_text"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    //userName: json["user_name"],
  );

  Map<String, dynamic> toJson() => {
    //"comment_id": commentId,
    "comment_text": commentText,
    "user_id": userId,
    "created_at": createdAt,
    //"user_name": userName,
  };

  @override
  String toString() {
    return "COMMENT TEXT $commentText \n PROFILE PIC $profilePic \n USERNAME $userName \n";
  }
}
