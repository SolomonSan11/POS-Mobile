class MenuTypeModel {
  final int? id;
  final String? menu;
  final int? price;

  MenuTypeModel({this.id, this.menu, this.price,});

  factory MenuTypeModel.fromMap(Map<String, dynamic> map) {
    print("id:${map["id"].runtimeType} && menu:${map["menu"].runtimeType} && price:${map["price"].runtimeType}");
    return MenuTypeModel(
        id: map["id"] ?? 0,
        menu: map["menu"] ?? "",
        price: map["price"]!="Null" ? map["price"] : "",
    );
  }

  toMap() {
    return {
      "id": id,
      "menu": menu,
      "price": price,
    };
  }
}
