class RefreshToken {
  String? refresh;

  RefreshToken({this.refresh});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (refresh != null) {
      data['refresh_token'] = refresh;
    }
    return data;
  }

  RefreshToken.fromJson(Map<String, dynamic> json) {
    refresh = json['token'];
  }
}
