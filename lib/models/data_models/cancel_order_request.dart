class CancelOrderRequest {
  String? orderId;
  String? reason;
  String? description;

  CancelOrderRequest({this.orderId, this.reason, this.description});

  factory CancelOrderRequest.fromJson(Map<String, dynamic> json) {
    return CancelOrderRequest(
      orderId: json["orderId"],
      reason: json["reason"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "reason": reason,
    "description": description,
  };
}
