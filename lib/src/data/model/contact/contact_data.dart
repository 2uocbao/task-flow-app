class ContactData {
  String? id;
  String? userId;
  String? userName;
  String? image;
  String? email;
  String? status;
  String? createdAt;

  ContactData({
<<<<<<< HEAD
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
=======
    String? id,
    String? userId,
    String? username,
    String? image,
    String? email,
    String? status,
    String? createdAt,
  });
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['username'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

<<<<<<< HEAD
  Map<String, dynamic> toJson(String toUser) {
    final data = <String, dynamic>{};
=======
  Map<String, dynamic> toJson(String fromUser, String toUser) {
    final data = <String, dynamic>{};
    data['from_user'] = fromUser;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    data['to_user'] = toUser;
    return data;
  }
}
