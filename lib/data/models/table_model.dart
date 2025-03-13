class TableModel {
  final int? id;
  final String? number;
  final String? menu_type;
  final int? menu_type_id;
  final int? status;

  TableModel({this.id, this.number, this.status,this.menu_type,this.menu_type_id});

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map["id"] ?? 0,
      number: map["number"] ?? "",
      status: map["status"] ?? "",
      menu_type: map["menu_type"] ?? "",
      menu_type_id: map["menu_type_id"] ?? ""
    );
  }

  toMap() {
    return {
      "id": id,
      "name": number,
      "description": status,
      "menu_type":menu_type,
      "menu_type_id":menu_type_id
    };
  }
}
