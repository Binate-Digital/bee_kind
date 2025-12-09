class VendorStatsResponseModel {
  VendorStatsResponseModel({
    this.success,
    this.totalSales,
    this.totalRevenue,
    this.storeRevenue,
    this.platformRevenue,
    this.completedOrders,
    this.pendingOrders,
    this.weeklySales,
    this.dailySales,
  });

  bool? success;
  num? totalSales;
  num? totalRevenue;
  num? storeRevenue;
  num? platformRevenue;
  int? completedOrders;
  int? pendingOrders;
  List<WeeklySales>? weeklySales;
  List<DailySales>? dailySales;

  factory VendorStatsResponseModel.fromJson(Map<String, dynamic> json) {
    final weekly = <WeeklySales>[];
    if (json['weeklySales'] != null && json['weeklySales'] is List) {
      for (final e in json['weeklySales']) {
        if (e is Map<String, dynamic>) {
          weekly.add(WeeklySales.fromJson(e));
        }
      }
    }

    final daily = <DailySales>[];
    if (json['dailySales'] != null && json['dailySales'] is List) {
      for (final e in json['dailySales']) {
        if (e is Map<String, dynamic>) {
          daily.add(DailySales.fromJson(e));
        }
      }
    }

    return VendorStatsResponseModel(
      success: json['success'] == null
          ? null
          : (json['success'] is bool
                ? json['success']
                : json['success'].toString().toLowerCase() == 'true'),
      totalSales: json['totalSales'],
      totalRevenue: json['totalRevenue'],
      storeRevenue: json['storeRevenue'],
      platformRevenue: json['platformRevenue'],
      completedOrders: json['completedOrders'] is int
          ? json['completedOrders']
          : (json['completedOrders'] != null
                ? int.tryParse(json['completedOrders'].toString())
                : null),
      pendingOrders: json['pendingOrders'] is int
          ? json['pendingOrders']
          : (json['pendingOrders'] != null
                ? int.tryParse(json['pendingOrders'].toString())
                : null),
      weeklySales: weekly,
      dailySales: daily,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'totalSales': totalSales,
    'totalRevenue': totalRevenue,
    'storeRevenue': storeRevenue,
    'platformRevenue': platformRevenue,
    'completedOrders': completedOrders,
    'pendingOrders': pendingOrders,
    'weeklySales': weeklySales?.map((e) => e.toJson()).toList(),
    'dailySales': dailySales?.map((e) => e.toJson()).toList(),
  };
}

class WeeklySales {
  WeeklySales({this.week, this.amount});
  int? week;
  num? amount;

  factory WeeklySales.fromJson(Map<String, dynamic> json) => WeeklySales(
    week: json['week'] is int
        ? json['week']
        : (json['week'] != null ? int.tryParse(json['week'].toString()) : null),
    amount: json['amount'],
  );

  Map<String, dynamic> toJson() => {'week': week, 'amount': amount};
}

class DailySales {
  DailySales({this.date, this.amount});
  String? date;
  num? amount;

  factory DailySales.fromJson(Map<String, dynamic> json) =>
      DailySales(date: json['date']?.toString(), amount: json['amount']);

  Map<String, dynamic> toJson() => {'date': date, 'amount': amount};
}
