class SaleModel {
  int table_number;
  String order_no;
  int dine_in_or_percel;
  int sub_total;
  int VAT;
  int grand_total;
  int paid_cash;
  int? paid_online;
  int refund;
  List<Product> products;
  final String? remark;

  SaleModel({
    required this.table_number,
    required this.order_no,
    required this.dine_in_or_percel,
    required this.sub_total,
    required this.VAT,
    required this.grand_total,
    required this.paid_cash,
    this.paid_online,
    required this.refund,
    required this.products,
    required this.remark,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      remark: json['remark'],
      table_number: json['table_number'],
      order_no: json['order_no'],
      dine_in_or_percel: json['dine_in_or_percel'],
      sub_total: json['sub_total'],
      VAT: json['VAT'],
      grand_total: json['grand_total'],
      paid_cash: json['paid_cash'],
      paid_online: json['paid_online'],
      refund: json['refund'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  SaleModel copyWith({
    int? menu_id,
    int? spicy_level_id,
    int? ahtone_level_id,
    int? remark_id,
    int? table_number,
    String? order_no,
    int? dine_in_or_percel,
    int? sub_total,
    int? VAT,
    int? discount,
    int? grand_total,
    int? paid_cash,
    int? paid_online,
    int? refund,
    List<Product>? products,
    String? remark,
  }) {
    return SaleModel(
      table_number: table_number ?? this.table_number,
      order_no: order_no ?? this.order_no,
      dine_in_or_percel: dine_in_or_percel ?? this.dine_in_or_percel,
      sub_total: sub_total ?? this.sub_total,
      VAT: VAT ?? this.VAT,
      grand_total: grand_total ?? this.grand_total,
      paid_cash: paid_cash ?? this.paid_cash,
      paid_online: paid_online ?? this.paid_online,
      refund: refund ?? this.refund,
      products: products ?? this.products,
      remark: remark ?? this.remark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'table_number': table_number,
      'order_no': order_no,
      'dine_in_or_percel': dine_in_or_percel,
      'sub_total': sub_total,
      'VAT': VAT,
      'grand_total': grand_total,
      'paid_cash': paid_cash,
      'paid_online': paid_online,
      'refund': refund,
      'remark': remark,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class Product {
  int product_id;
  int qty;
  int price;
  int total_price;
  bool? is_gram;

  Product({
    required this.product_id,
    required this.qty,
    required this.price,
    required this.total_price,
    this.is_gram,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'],
      qty: json['qty'],
      price: json['price'],
      total_price: json['total_price'],
      is_gram: json['is_gram'] == null
          ? false
          : json["is_gram"] == 0
              ? false
              : json["is_gram"] == 1
                  ? true
                  : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'qty': qty,
      'price': price,
      'total_price': total_price,
    };
  }
}
