class SaleRecordModel {
  final int? id;
  final String? monthYear;
  final String? netAmount;
  final String? created_at;
  final String? updated_at;
  // final String? past_month;


  SaleRecordModel({
   this.id,
    this.monthYear,
    this.netAmount,
    this.created_at,
    this.updated_at
  });

  factory SaleRecordModel.fromMap(Map<String, dynamic> map) {
    print("ffsf${map}");
    return SaleRecordModel(
      id: map["id"] ?? 0,
      monthYear: map["monthYear"] ?? "",
      netAmount: map["netAmount"] ?? "",
      created_at: map["created_at"] ?? "",
      updated_at: map["updated_at"] ?? "",
    );
  }
}
