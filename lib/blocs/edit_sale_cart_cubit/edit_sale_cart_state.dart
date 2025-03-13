import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

class EditSaleCartState {
  List<CartItem> items;
  int tableNumber;
  String remark;

  EditSaleCartState({
    required this.items,
    required this.tableNumber,
    required this.remark,
  });
}
