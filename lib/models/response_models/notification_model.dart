class GetNotificationsResponseModel {
  bool? status;
  dynamic message;
  List<NotificationItem>? data;

  GetNotificationsResponseModel({this.status, this.message, this.data});

  GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationItem {
  dynamic id;
  dynamic senderId;
  dynamic receiverId;
  String? type;
  String? message;
  bool? isRead;
  dynamic metadata;
  String? createdAt;
  String? updatedAt;
  int? v;

  NotificationItem({
    this.id,
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.isRead,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    senderId = json['senderId']; // can be String or null
    receiverId = json['receiverId'];
    type = json['type'];
    message = json['message'];
    isRead = json['isRead'];
    metadata = json['metadata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    // __v may be int or double/string; normalize to int
    if (json['__v'] != null) {
      final vv = json['__v'];
      if (vv is num) {
        v = vv.toInt();
      } else {
        v = int.tryParse(vv.toString());
      }
    } else {
      v = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "type": type,
      "message": message,
      "isRead": isRead,
      "metadata": metadata,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}
