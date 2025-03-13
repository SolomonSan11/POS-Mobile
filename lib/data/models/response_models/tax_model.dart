class VATModel {
  int id;
  String name;
  String type;
  int? percentage;
  String? amount;

  VATModel({
    required this.id,
    required this.name,
    required this.type,
    required this.percentage,
    this.amount,
  });

  factory VATModel.fromMap(Map<String, dynamic> map) {
    return VATModel(
      id: map['id'],
      name: map['name'] ?? "",
      type: map['type'] ?? "",
      percentage: map['percentage'] ?? 0,
      amount: map['amount'] != null ? map['amount'].toString() : null,
    );
  }
}
