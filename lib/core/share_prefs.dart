import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';

class SharedPref {
  final String shop_token = "SHOP_TOKEN";
  final String pendingOrdersKey = "PENDING_ORDERS";

  // Save a simple string value
  void setData({required String value, required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  // Clear data using a key
  Future<void> clearData({required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }

  // Get string data by key
  Future<String> getData({required String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? "";
  }

  // Save a list of PendingOrder objects to SharedPreferences
  Future<void> savePendingOrders(List<PendingOrder> orders) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Convert list of PendingOrder to JSON string
    String encodedOrders = jsonEncode(orders.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(pendingOrdersKey, encodedOrders);
  }

  // Load a list of PendingOrder objects from SharedPreferences
  Future<List<PendingOrder>> loadPendingOrders() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savedOrders = sharedPreferences.getString(pendingOrdersKey);

    if (savedOrders != null) {
      // Decode the JSON string and convert to List<PendingOrder>
      List<dynamic> decodedOrders = jsonDecode(savedOrders);
      return decodedOrders.map((e) => PendingOrder.fromJson(e)).toList();
    }
    return [];
  }

  // Clear pending orders data
  Future<void> clearPendingOrders() async {
    await clearData(key: pendingOrdersKey);
  }
}
