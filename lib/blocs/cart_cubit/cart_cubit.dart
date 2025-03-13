import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:meta/meta.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(
          CartState(
            remark: "",
            items: [],
            tableNumber: 0,
            dine_in_or_percel: 1,
            tableId: 0,
            menu_type_id: 0
          ),
        );

  void updateCart({
    required String remark,
    required List<CartItem> items,
    required int dine_in_or_percel,
    required int tableNumber,
    required int tableId,
    required int menu_type_id,
  }) {
    emit(
      CartState(
        dine_in_or_percel: dine_in_or_percel,
        remark: remark,
        tableNumber: tableNumber,
        items: items,
        tableId: tableId,
        menu_type_id: menu_type_id
      ),
    );
  }

  ///add table number
  void addTableNumber({
    required int tableNumber,
    required int menu_type_id,
    required int tableId,
  }) {
    emit(
      CartState(
        dine_in_or_percel: state.dine_in_or_percel,
        remark: state.remark,
        tableNumber: tableNumber,
        menu_type_id: menu_type_id,
        items: state.items,
        tableId: tableId,
      ),
    );
  }

  // Method to add an item to the cart
  void addToCartByQuantity({
    required CartItem item,
    required int quantity,
  }) async {
    List<CartItem> updatedItems = state.items;

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.name == item.name && cartItem.id == item.id) {
          cartItem.qty = quantity;
          cartItem.totalPrice = (cartItem.qty * cartItem.price);
        }
      }
      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: quantity,
            totalPrice: item.price * quantity,
          ),
        );

      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    }
  }

  // Method to add an item to the cart
  void addToCartByGram({
    required CartItem item,
    required int gram,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    //print("gram per price : ${getPriceByGram(gram).toString()} / ${gram}");

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.id == item.id && cartItem.name == item.name) {
          cartItem.qty = gram;
          cartItem.totalPrice =
              getPriceByGram(weight: gram, priceGap: cartItem.price);
        }
      }
      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: gram,
            totalPrice: getPriceByGram(weight: gram, priceGap: item.price),
          ),
        );

      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    }
  }

  ///to change the quantity of the cart item
  void changeQuantity({
    required CartItem item,
    required int quantity,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    if (checkIsProductExisted(item)) {
      for (var cartItem in updatedItems) {
        if (cartItem.id == item.id && cartItem.name == item.name) {
          cartItem.qty = quantity;
          cartItem.totalPrice = (cartItem.qty * cartItem.price);
        }
      }
      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    } else {
      List<CartItem> updatedItems = List.from(state.items)
        ..add(
          item.copyWith(
            qty: 1,
            totalPrice: item.price,
          ),
        );

      emit(
        CartState(
          dine_in_or_percel: state.dine_in_or_percel,
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
          tableId: state.tableId,
          menu_type_id: state.menu_type_id
        ),
      );
    }
  }

  // Method to remove an item from the cart
  void removeFromCart({
    required CartItem item,
  }) async {
    List<CartItem> updatedItems = List.from(state.items);

    updatedItems.removeWhere(
      (element) => element.id == item.id && element.name == item.name,
    );

    emit(
      CartState(
        dine_in_or_percel: state.dine_in_or_percel,
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: updatedItems,
        tableId: state.tableId,
        menu_type_id: state.menu_type_id
      ),
    );
  }

  // Method to remove an item from the cart
  Future<void> clearOrderr() async {
    emit(
      CartState(
        dine_in_or_percel: 1,
        remark: "",
        tableNumber: 0,
        items: [],
        tableId: 0,
        menu_type_id: 0
      ),
    );
  }

  ///to get total amount of cart items
  int getTotalAmount() {
    int totalAmount = 0;
    state.items.forEach((element) {
      //totalAmount += element.qty * num.parse(element.price);
      totalAmount += element.totalPrice;
    });

    return totalAmount;
  }

  ///to checkk if the selected product is existed in the cart
  bool checkIsProductExisted(CartItem item) {
    return state.items.any(
      (p) => p.name == item.name,
    );
  }
}

////class model to mark pending order
class PendingOrderModel {
  final String? mark;
  final DateTime? date;
  final num? orderAmount;

  PendingOrderModel({
    this.date,
    this.mark,
    this.orderAmount,
  });
}
