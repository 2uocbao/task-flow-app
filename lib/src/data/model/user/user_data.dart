class UserData {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? imagePath;
  String? mention;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.imagePath,
    this.mention,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mention = json['mention'];

    imagePath = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mention'] = mention;
    data['image'] = imagePath;
    return data;
  }
}
