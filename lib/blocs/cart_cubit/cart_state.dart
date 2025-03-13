// ignore_for_file: must_be_immutable
part of 'cart_cubit.dart';

@immutable
class CartState {
  List<CartItem> items;
  int tableNumber;
  int tableId;
  String remark;
  int menu_type_id;
  int dine_in_or_percel;

  CartState({
    required this.items,
    required this.tableNumber,
    required this.tableId,
    required this.remark,
    required this.menu_type_id,
    required this.dine_in_or_percel,
  });
}
