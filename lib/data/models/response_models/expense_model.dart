class ExpenseModel {
  int? id;
  String? name;
  int? price;
  int? type;
  String? created_at;
  String? updated_at;

  ExpenseModel({
    this.id,
    this.name,
    this.price,
    this.created_at,
    this.type,
    this.updated_at,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: json['price'] ?? 0,
      type: json['type'] ?? 0,
      created_at: json['created_at'] ?? 0,
      updated_at: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type':type,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
