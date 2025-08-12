class TaskData {
  String? id;
  String? creatorId;
<<<<<<< HEAD
=======
  String? assignTo;
  String? imageAssigner;
  String? usernameAssigner;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
=======
    this.assignTo,
    this.imageAssigner,
    this.usernameAssigner,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
=======
    String? assignTo,
    String? imageAssigner,
    String? usernameAssigner,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
=======
      assignTo: assignTo ?? this.assignTo,
      imageAssigner: imageAssigner ?? this.imageAssigner,
      usernameAssigner: usernameAssigner ?? this.usernameAssigner,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
=======
    assignTo = json['assign_to'];
    imageAssigner = json['imageAssigner'];
    usernameAssigner = json['usernameAssigner'];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
