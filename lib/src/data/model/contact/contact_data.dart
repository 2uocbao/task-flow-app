class ContactData {
  String? id;
  String? userId;
  String? userName;
  String? image;
  String? email;
  String? status;
  String? createdAt;

  ContactData({
    this.id,
    this.userId,
    this.userName,
    this.image,
    this.email,
    this.status,
    this.createdAt,
  });

  ContactData copyWith({
    String? userName,
    String? image,
    String? email,
  }) {
    return ContactData(
      userName: userName ?? this.userName,
      image: image ?? this.image,
      email: email ?? this.email,
    );
  }

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['username'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson(String toUser) {
    final data = <String, dynamic>{};
    data['to_user'] = toUser;
    return data;
  }
}
