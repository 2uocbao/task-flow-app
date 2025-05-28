class ContactData {
  String? id;
  String? userId;
  String? userName;
  String? image;
  String? email;
  String? status;
  String? createdAt;

  ContactData({
    String? id,
    String? userId,
    String? username,
    String? image,
    String? email,
    String? status,
    String? createdAt,
  });

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['username'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson(String fromUser, String toUser) {
    final data = <String, dynamic>{};
    data['from_user'] = fromUser;
    data['to_user'] = toUser;
    return data;
  }
}
