class NotificationData {
  int? id;
  String? senderId;
  String? contentId;
  String? senderName;
  String? image;
  String? typeContent;
  String? titleTask;
  String? status;
  String? type;
  String? createdAt;

  NotificationData({
    this.id,
    this.senderId,
    this.contentId,
    this.senderName,
    this.image,
    this.typeContent,
    this.titleTask,
    this.status,
    this.type,
    this.createdAt,
  });

  NotificationData copyWith({
    int? id,
    String? senderId,
    String? contentId,
    String? senderName,
    String? image,
    String? typeContent,
    String? titleTask,
    String? status,
    String? type,
    String? createdAt,
  }) {
    return NotificationData(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      contentId: contentId ?? this.contentId,
      senderName: senderName ?? this.senderName,
      image: image ?? this.image,
      typeContent: typeContent ?? this.typeContent,
      titleTask: titleTask ?? this.titleTask,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['sender_id'] != null) {
      senderId = json['sender_id'];
    }
    contentId = json['content_id'];
    if (json['sender_name'] != null) {
      senderName = json['sender_name'];
    }
    if (json['image'] != null) {
      image = json['image'];
    }
    typeContent = json['type_content'];
    if (json['title_task'] != null) {
      titleTask = json['title_task'];
    }
    if (json['status'] != null) {
      status = json['status'];
    }
    type = json['type'];
    if (json['createdAt'] != null) {
      createdAt = json['createdAt'];
    }
  }
}
