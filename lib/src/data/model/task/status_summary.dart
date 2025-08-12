class StatusSummary {
  String? status;
  int? quantity;

  StatusSummary({this.status, this.quantity});

  StatusSummary.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    quantity = json['quantity'];
  }
}
