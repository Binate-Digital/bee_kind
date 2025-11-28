class CardResponseModel {
  bool? status;
  String? message;
  CardData? data;

  CardResponseModel({this.status, this.message, this.data});

  factory CardResponseModel.fromJson(Map<String, dynamic> json) {
    return CardResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? CardData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class CardData {
  String? defaultPaymentMethodId;
  List<CardModel>? cards;

  CardData({this.defaultPaymentMethodId, this.cards});

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      defaultPaymentMethodId: json['defaultPaymentMethodId'],
      cards: json['cards'] != null
          ? List<CardModel>.from(
              json['cards'].map((x) => CardModel.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultPaymentMethodId': defaultPaymentMethodId,
      'cards': cards?.map((x) => x.toJson()).toList(),
    };
  }
}

class CardModel {
  String? id;
  String? brand;
  String? last4;
  int? expMonth;
  int? expYear;
  bool? isDefault;

  CardModel({
    this.id,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
    this.isDefault,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      brand: json['brand'],
      last4: json['last4'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'last4': last4,
      'exp_month': expMonth,
      'exp_year': expYear,
      'isDefault': isDefault,
    };
  }
}
