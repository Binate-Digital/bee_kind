class OtpVerificationDataModel {
  String? userId;
  String? otp;
  String? purpose;

  OtpVerificationDataModel({this.userId, this.otp, this.purpose});

  OtpVerificationDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    otp = json['otp'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['otp'] = otp;
    data['purpose'] = purpose;
    return data;
  }
}
