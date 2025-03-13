class CartItem {
  int id;
  String name;
  String name_th;
  int price;
  int qty;
  int totalPrice;
  bool is_gram;
  int is_buffet;

  CartItem({
    required this.id,
    required this.name,
    required this.name_th,
    required this.price,
    required this.qty,
    required this.totalPrice,
    required this.is_gram,
    required this.is_buffet,
  });

  toMap() {
    return {
      "product_id": this.id,
      "name" : name,
      "name_th" : name_th,
      "qty": qty,
      "price": price,
      "total_price": totalPrice,
      "is_buffet": is_buffet,
    };
  }

  toJson() {
    return {
      "product_id": this.id,
      "qty": this.qty,
      "price": this.price,
      "total_price": this.totalPrice,
      "is_buffet": this.is_buffet,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map["product_id"] ?? 0,
      name: map["name"] ?? "",
      name_th: map["name_th"] ?? "",
      price: map["price"],
      qty: map["qty"] ?? 0,
      totalPrice: map["total_price"] ?? "0",
      is_gram: map["is_gram"] ?? false,
      is_buffet: map["is_buffet"] ?? 0,
    );
  }

  CartItem copyWith({
    int? id,
    String? name,
    String? name_th,
    int? price,
    int? qty,
    int? totalPrice,
  }) =>
      CartItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        qty: qty ?? this.qty,
        totalPrice: totalPrice ?? this.totalPrice,
        is_gram: is_gram,
        name_th: name_th ?? this.name_th,
        is_buffet: is_buffet,
      );
}

// class CartItem {
//   String? product_name;
//   String? cart_id;
//   String? product_id;
//   int quantity;
//   int? price;
//   String? status;

//   CartItem({
//     this.product_name,
//     this.cart_id,
//     this.product_id,
//     required this.quantity,
//     this.price,
//     this.status,
//   });

//   factory CartItem.fromMap(Map<String, dynamic> map) {
//     return CartItem(
//       product_name: map['product_name'],
//       cart_id: map['cart_id'],
//       product_id: map['product_id'],
//       quantity: map['quantity'],
//       price: map['price'],
//       status: map['status'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'product_name': product_name,
//       'cart_id': cart_id,
//       'product_id': product_id,
//       'quantity': quantity,
//       'price': price,
//       'status': status,
//     };
//   }

//   CartItem copyWith({
//     String? product_name,
//     String? cart_id,
//     String? product_id,
//     int? quantity,
//     int? price,
//     String? status,
//   }) {
//     return CartItem(
//       product_name: product_name ?? this.product_name,
//       cart_id: cart_id ?? this.cart_id,
//       product_id: product_id ?? this.product_id,
//       quantity: quantity ?? this.quantity,
//       price: price ?? this.price,
//       status: status ?? this.status,
//     );
//   }
// }
