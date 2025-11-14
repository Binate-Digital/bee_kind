class OtpVerificationResponseModel {
  bool? status;
  String? message;
  Data? data;

  OtpVerificationResponseModel({this.status, this.message, this.data});

  OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
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
  dynamic phoneNumber;
  String? role;
  String? stripeCustomerId;
  String? userAuthToken;

  Data({
    this.sId,
    this.phoneNumber,
    this.role,
    this.stripeCustomerId,
    this.userAuthToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    stripeCustomerId = json['stripeCustomerId'];
    userAuthToken = json['userAuthToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['phoneNumber'] = phoneNumber;
    data['role'] = role;
    data['stripeCustomerId'] = stripeCustomerId;
    data['userAuthToken'] = userAuthToken;
    return data;
  }
}
