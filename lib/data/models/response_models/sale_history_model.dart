class SaleHistoryModel {
  final int id;
  final String orderNo;
  final String tableNumber;
  final int dine_in_or_percel;
  final int subTotal;
  final int VAT;
  final int discount;
  final int grandTotal;
  final int paidCash;
  final int paidOnline;
  final String remark;
  final String created_at;
  final List<SaleProduct> products;

  SaleHistoryModel({
    required this.id,
    required this.orderNo,
    required this.tableNumber,
    required this.dine_in_or_percel,
    required this.subTotal,
    required this.VAT,
    required this.discount,
    required this.grandTotal,
    required this.paidCash,
    required this.paidOnline,
    required this.remark,
    required this.created_at,
    required this.products,
  });

  factory SaleHistoryModel.fromMap(Map<String, dynamic> map) {
    return SaleHistoryModel(
      id: map['id'] ?? 0,
      orderNo: map['order_no'] ?? '',
      // paymentTypeId: map['payment_type_id'],
      tableNumber: map['table_number'] ?? '',
      dine_in_or_percel: map['dine_in_or_percel'] ?? 0,
      subTotal: map['sub_total'] ?? 0,
      VAT: map['VAT'] ?? 0,
      discount: map['discount'] ?? 0,
      grandTotal: map['grand_total'] ?? 0,
      paidCash: map['paid_cash'] ?? 0,
      paidOnline: map['paid_online'] ?? 0,

      remark: map['remark'] ?? '',
      created_at: map['created_at'] ?? '',

      products: List<SaleProduct>.from(
        map['products']?.map((x) => SaleProduct.fromMap(x)) ?? [],
      ),
    );
  }
}

class AhtoneLevel {
  final int id;
  final String name;

  AhtoneLevel({
    required this.id,
    required this.name,
  });

  factory AhtoneLevel.fromMap(Map<String, dynamic> map) {
    return AhtoneLevel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}

class SaleProduct {
  final int productId;
  final String name;
  final int qty;
  final bool isGram;
  final int is_buffet;
  final int price;
  final int totalPrice;

  SaleProduct({
    required this.productId,
    required this.name,
    required this.qty,
    required this.isGram,
    required this.is_buffet,
    required this.price,
    required this.totalPrice,
  });

  factory SaleProduct.fromMap(Map<String, dynamic> map) {
    return SaleProduct(
      productId: map['product_id'] ?? 0,
      name: map['name'] ?? '',
      qty: map['qty'] ?? 0,
      isGram: map['is_gram'],
      is_buffet: map['is_buffet'] ?? 0,
      price: map['price'] ?? 0,
      totalPrice: map['total_price'] ?? 0,
    );
  }
}
