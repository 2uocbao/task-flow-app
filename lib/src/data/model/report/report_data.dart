class ReportData {
  String? id;
  String? type;
  String? filename;
  String? filePath;
  String? externalUrl;
  String? createdAt;

  ReportData({
    this.id,
    this.type,
    this.filename,
    this.filePath,
    this.externalUrl,
    this.createdAt,
  });

  ReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    filename = json['file_name'];
    filePath = json['file_path'];
    externalUrl = json['external_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson(String userId, String taskId, String url) {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['task_id'] = taskId;
    data['external_url'] = url;
    return data;
  }
}
