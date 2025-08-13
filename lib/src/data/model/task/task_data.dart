class TaskData {
  String? id;
  String? creatorId;
  String? title;
  String? description;
  String? status;
  String? priority;
  String? createdAt;
  String? dueAt;
  String? startDate;
  int? commentCount;
  int? reportCount;

  TaskData({
    this.id,
    this.creatorId,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.createdAt,
    this.startDate,
    this.dueAt,
  });

  TaskData copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? createdAt,
    String? startDate,
    String? dueAt,
    int? commentCount,
    int? reportCount,
  }) {
    return TaskData(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: this.createdAt,
      startDate: startDate ?? this.startDate,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  TaskData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['user_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    priority = json['priority'];
    createdAt = json['created_at'];
    dueAt = json['due_at'];
    startDate = json['start_date'];
    commentCount = json['commentCount'];
    reportCount = json['reportCount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (creatorId != null) {
      data['creatorId'] = creatorId;
    }

    if (title != null) {
      data['title'] = title;
    }

    if (description != null) {
      data['description'] = description;
    }

    if (priority != null) {
      data['priority'] = priority;
    }

    if (status != null) {
      data['status'] = status;
    }

    if (dueAt != null) {
      data['due_at'] = dueAt;
    }

    if (startDate != null) {
      data['start_date'] = startDate;
    }
    return data;
  }
}
