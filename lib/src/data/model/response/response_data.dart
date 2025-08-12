class ResponseData<T> {
  T? data;
  int? status;
  String? message;

  ResponseData({this.status, this.data, this.message});

  ResponseData.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonData) {
    status = json['status'];
    if (json['data'] != null) {
      data = fromJsonData(json['data']);
    }
    message = json['message'];
  }

  ResponseData.fromJsonToken(Map<String, dynamic> json) {
<<<<<<< HEAD
    if (json['data'] != null) {
      data = json['data'];
=======
    if (json['token'] != null) {
      data = json['token'];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    }
  }

  ResponseData.fromBase(Map<String, dynamic> json) {
    if (json['message'] != null) {
      data = json['message'];
    }
  }
}
