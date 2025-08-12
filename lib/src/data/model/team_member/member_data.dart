class MemberData {
  String? id;
  String? memberId;
  String? memberName;
  String? memberImage;
  String? joinedAt;

  MemberData(
      {this.id,
      this.memberId,
      this.memberName,
      this.memberImage,
      this.joinedAt});

  MemberData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    memberName = json['member_name'];
    memberImage = json['member_image'];
    joinedAt = json['joined_at'];
  }
}
