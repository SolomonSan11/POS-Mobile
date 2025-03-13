import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

class PendingOrder {
  List<CartItem> items;
  final int tableNumber;
  final int tableId;  
  final String remark;
  // final String tableType;
  final int dine_in_or_percel;
  final String orderUniqueId;
  final DateTime time;
  final int menu_type_id;

  PendingOrder({
    required this.items,
    required this.tableNumber,
    required this.tableId,
    required this.remark,
    //required this.tableType,
    required this.dine_in_or_percel,
    required this.orderUniqueId,
    required this.time,
    required this.menu_type_id
  });

  // Convert PendingOrder to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'tableNumber': tableNumber,
      'tableId': tableId,
      'remark': remark,
      'dine_in_or_percel': dine_in_or_percel,
      'orderUniqueId': orderUniqueId,
      'time': time.toIso8601String(), // Convert DateTime to ISO 8601 string
      'menu_type_id': menu_type_id
    };
  }

  // Convert JSON to PendingOrder
  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    return PendingOrder(
      items: (json['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      tableNumber: json['tableNumber'] ?? 0,
      menu_type_id: json['menu_type_id'] ?? 0,
      //tableType: json['tableType'] ?? "Standart",
      tableId: json['tableId'] ?? 0,
      remark: json['remark'],
      dine_in_or_percel: json['dine_in_or_percel'],
      orderUniqueId: json['orderUniqueId'],
      time: DateTime.parse(
          json['time']), // Convert ISO 8601 string back to DateTime
    );
  }

  // Add the copyWith method
  PendingOrder copyWith({
    List<CartItem>? items,
    int? tableNumber,
    int? tableId,
    String? remark,
    int? dine_in_or_percel,
    String? orderUniqueId,
    DateTime? time,
    int? menu_type_id,
  }) {
    return PendingOrder(
      items: items ?? this.items,
      tableNumber: tableNumber ?? this.tableNumber,
      tableId: tableId ?? this.tableId,
      remark: remark ?? this.remark,
      dine_in_or_percel: dine_in_or_percel ?? this.dine_in_or_percel,
      orderUniqueId: orderUniqueId ?? this.orderUniqueId,
      time: time ?? this.time,
      menu_type_id: menu_type_id ?? this.menu_type_id,
    );
  }

}
