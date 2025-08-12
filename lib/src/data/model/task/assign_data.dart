class AssignData {
  String? id;
  String? assignerId;
  String? name;
  String? mention;
  String? image;
  String? joinedAt;

  AssignData({
    this.id,
    this.assignerId,
    this.name,
    this.mention,
    this.image,
    this.joinedAt,
  });

  AssignData.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['assigner_id'] != null) {
      assignerId = json['assigner_id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['mention'] != null) {
      mention = json['mention'];
    }
    if (json['image'] != null) {
      image = json['image'];
    }
    if (json['joined_at'] != null) {
      joinedAt = json['joined_at'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': assignerId,
      'display': mention,
      'name': name,
      'image': image,
    };
  }
}
