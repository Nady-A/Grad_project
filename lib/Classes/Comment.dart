class Comment {
  String commentId;
  String commentText;
  String userId;
  String userName;

  Comment({
    this.commentId,
    this.commentText,
    this.userId,
    this.userName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json["comment_id"],
    commentText: json["comment_text"],
    userId: json["user_id"],
    userName: json["user_name"],
  );

  Map<String, dynamic> toJson() => {
    "comment_id": commentId,
    "comment_text": commentText,
    "user_id": userId,
    "user_name": userName,
  };
}
