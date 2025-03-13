class PaymentModel {
  final int? id;
  final String? name;
  final String? type;
  final String? image_path;

  PaymentModel({
    this.id,
    this.name,
    this.type,
    this.image_path,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      type: map["type"] ?? "",
      image_path: map["image_path"] ?? "",
    );
  }
}
