class CommentData {
  int? id;
  String? creatorId;
  String? text;
  String? mentionId;
  String? username;
  String? image;
  String? createdAt;
  String? updatedAt;

  CommentData({
    this.id,
    this.creatorId,
    this.mentionId,
    this.text,
    this.username,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  CommentData copyWith({
    int? id,
    String? username,
    String? creatorId,
    String? mentionId,
    String? text,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    return CommentData(
      id: id ?? this.id,
      username: username ?? this.username,
      creatorId: creatorId ?? this.creatorId,
      mentionId: mentionId ?? this.mentionId,
      text: text ?? this.text,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    username = json['username'];
    image = json['image'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (mentionId != null) {
      data['mention'] = mentionId;
    }
    if (text != null) {
      data['text'] = text;
    }
    return data;
  }
}
