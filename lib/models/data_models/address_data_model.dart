class AddressDataModel {
  String? addressId;
  LocationModel? location;
  final String? addressName;
  String? floorNumber;
  String? apartmentNumber;
  bool? isDefault;

  AddressDataModel({
    this.addressId,
    this.addressName,
    this.location,
    this.floorNumber,
    this.apartmentNumber,
    this.isDefault,
  });

  factory AddressDataModel.fromJson(Map<String, dynamic> json) {
    return AddressDataModel(
      addressId: json['addressId'],
      addressName: json['addressName'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      floorNumber: json['floorNumber'],
      apartmentNumber: json['apartmentNumber'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addressId": addressId,
      "addressName": addressName,
      "location": location?.toJson(),
      "floorNumber": floorNumber,
      "apartmentNumber": apartmentNumber,
      "isDefault": isDefault,
    };
  }
}

class LocationModel {
  String? type;
  List<double>? coordinates;
  String? address;
  String? addressName;

  LocationModel({this.type, this.coordinates, this.address, this.addressName});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      addressName: json["addressName"],
      type: json["type"],
      coordinates: json["coordinates"] != null
          ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
          : null,
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addressName": addressName,
      "type": type,
      "coordinates": coordinates,
      "address": address,
    };
  }
}
