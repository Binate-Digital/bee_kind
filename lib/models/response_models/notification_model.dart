// class GetNotificationsResponseModel {
//   bool? status;
//   dynamic message;
//   List<NotificationItem>? data;
//
//   GetNotificationsResponseModel({this.status, this.message, this.data});
//
//   GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//
//     if (json['data'] != null) {
//       data = [];
//       json['data'].forEach((v) {
//         data!.add(NotificationItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "status": status,
//       "message": message,
//       "data": data?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class NotificationItem {
//   dynamic id;
//   dynamic senderId;
//   dynamic receiverId;
//   String? type;
//   String? message;
//   bool? isRead;
//   dynamic metadata;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//
//   NotificationItem({
//     this.id,
//     this.senderId,
//     this.receiverId,
//     this.type,
//     this.message,
//     this.isRead,
//     this.metadata,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   NotificationItem.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     senderId = json['senderId']; // can be String or null
//     receiverId = json['receiverId'];
//     type = json['type'];
//     message = json['message'];
//     isRead = json['isRead'];
//     metadata = json['metadata'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//
//     // __v may be int or double/string; normalize to int
//     if (json['__v'] != null) {
//       final vv = json['__v'];
//       if (vv is num) {
//         v = vv.toInt();
//       } else {
//         v = int.tryParse(vv.toString());
//       }
//     } else {
//       v = null;
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "senderId": senderId,
//       "receiverId": receiverId,
//       "type": type,
//       "message": message,
//       "isRead": isRead,
//       "metadata": metadata,
//       "createdAt": createdAt,
//       "updatedAt": updatedAt,
//       "__v": v,
//     };
//   }
// }

class GetNotificationsResponseModel {
  bool? status;
  String? message;
  List<NotificationItem>? data;

  GetNotificationsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => NotificationItem.fromJson(e))
          .toList();
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
  String? id;
  dynamic senderId; // can be String or null
  String? receiverId;
  String? type;
  String? message;
  bool? isRead;
  NotificationMetadata? metadata;
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
    id = json['_id']?.toString();
    senderId = json['senderId'];
    receiverId = json['receiverId']?.toString();
    type = json['type']?.toString();
    message = json['message']?.toString();
    isRead = json['isRead'];

    metadata = json['metadata'] != null
        ? NotificationMetadata.fromJson(json['metadata'])
        : null;

    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();

    if (json['__v'] != null) {
      final vv = json['__v'];
      if (vv is num) {
        v = vv.toInt();
      } else {
        v = int.tryParse(vv.toString());
      }
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
      "metadata": metadata?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class NotificationMetadata {
  String? reviewId;
  String? productId;
  String? orderId;
  String? type;
  String? status;

  NotificationMetadata({
    this.reviewId,
    this.productId,
    this.orderId,
    this.type,
    this.status,
  });

  NotificationMetadata.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId']?.toString();
    productId = json['productId']?.toString();
    orderId = json['orderId']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "reviewId": reviewId,
      "productId": productId,
      "orderId": orderId,
      "type": type,
      "status": status,
    };
  }
}