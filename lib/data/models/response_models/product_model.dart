class ProductModel {
  final int? id;
  final String name;
  final String? name_th;
  final int? price;
  final int? category_id;
  final is_gram;
  final int? qty;
  final int is_buffet;
  final String? category;
  final bool? is_default;
  final String? language;
  final String? product_number;

  ProductModel({
    this.id,
    required this.name,
    this.name_th,
    this.price,
    this.category_id,
    this.is_gram,
    this.qty,
    this.category,
    this.is_default,
    required this.is_buffet,
    this.language,
    this.product_number,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    //print("check object::${json.toString()}");
    return ProductModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      name_th: json['name_th'] ?? "",
      price: json['prices'] ?? 0,
      is_gram: json['is_gram'] ?? "",
      category: json['category'] ?? "",
      qty: json['qty'] ?? 0,
      is_default: json['is_default'] ?? false,
      category_id: json['category_id'],
      is_buffet: json['is_buffet'] ?? 0,
      product_number: json['product_number'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": category_id,
      "name": name,
      "qty": qty.toString(),
      "is_gram": is_gram,
      "is_buffet": is_buffet == 1 ? true : false,
      "prices": price,
      "is_default": is_default,
      "language": language,
      "product_number": product_number,
    };
  }
}

class ProductImage {
  final int? id;
  final int? productId;
  final String? filePath;

  ProductImage({
    this.id,
    this.productId,
    this.filePath,
  });

  factory ProductImage.fromMap(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      filePath: json['file_path'],
    );
  }
}
