// ignore: file_names

class AddCardResponseModel {
  bool? status;
  String? message;
  AddCardData? data;

  AddCardResponseModel({this.status, this.message, this.data});

  factory AddCardResponseModel.fromJson(Map<String, dynamic> json) {
    return AddCardResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? AddCardData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class AddCardData {
  String? paymentMethodId;

  AddCardData({this.paymentMethodId});

  factory AddCardData.fromJson(Map<String, dynamic> json) {
    return AddCardData(paymentMethodId: json['paymentMethodId']);
  }

  Map<String, dynamic> toJson() {
    return {'paymentMethodId': paymentMethodId};
  }
}
