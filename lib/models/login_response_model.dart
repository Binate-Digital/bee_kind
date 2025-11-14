class LoginResponseModel {
  bool? status;
  String? message;
  Data? data;

  LoginResponseModel({this.status, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? email;
  String? role;
  String? stripeCustomerId;
  String? userAuthToken;

  Data({
    this.sId,
    this.email,
    this.role,
    this.stripeCustomerId,
    this.userAuthToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    stripeCustomerId = json['stripeCustomerId'];
    userAuthToken = json['userAuthToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['role'] = role;
    data['stripeCustomerId'] = stripeCustomerId;
    data['userAuthToken'] = userAuthToken;
    return data;
  }
}
