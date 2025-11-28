class AddressResponseModel {
  bool? status;
  String? message;
  List<AddressModel>? data;

  AddressResponseModel({this.status, this.message, this.data});

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<AddressModel>.from(
              json['data'].map((x) => AddressModel.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class AddressModel {
  String? type;
  List<double>? coordinates;
  String? address;
  String? floorNumber;
  String? apartmentNumber;
  String? suiteNumber;
  bool? isDefault;
  String? id;

  String? addressName;

  AddressModel({
    this.type,
    this.coordinates,
    this.address,
    this.floorNumber,
    this.apartmentNumber,
    this.suiteNumber,
    this.isDefault,
    this.id,
    this.addressName,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
      address: json['address'],
      floorNumber: json['floorNumber'],
      apartmentNumber: json['apartmentNumber'],
      suiteNumber: json['suiteNumber'],
      isDefault: json['isDefault'],
      id: json['_id'],
      addressName: json.containsKey('addressName') ? json['addressName'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'address': address,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'suiteNumber': suiteNumber,
      'isDefault': isDefault,
      '_id': id,

      'addressName': addressName,
    };
  }
}
