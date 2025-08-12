class TeamData {
  String? id;
  String? name;
  String? creatorId;
  String? creatorImage;
  String? creatorName;
  String? createdAt;

  TeamData(
      {this.id,
      this.name,
      this.creatorId,
      this.creatorImage,
      this.creatorName,
      this.createdAt});

  TeamData copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? creatorImage,
    String? creatorName,
    String? createdAt,
  }) {
    return TeamData(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      creatorImage: creatorImage ?? this.creatorImage,
      creatorName: creatorName ?? this.creatorName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  TeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creatorId = json['creator_id'];
    creatorImage = json['creator_image'];
    creatorName = json['creator_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
