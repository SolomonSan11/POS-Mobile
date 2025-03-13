import 'package:bloc/bloc.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

class EditSaleCartCubit extends Cubit<EditSaleCartState> {
  EditSaleCartCubit()
      : super(
          EditSaleCartState(
            remark: "",
            items: [],
            tableNumber: 0,
          ),
        );

  ///add menu model
  void addAllData({
    required List<CartItem> items,
    required int tableNumber,
    required String remark,
  }) {
    emit(
      EditSaleCartState(
        remark: remark,
        tableNumber: tableNumber,
        items: items,
      ),
    );
  }

  void addAdditionalData({
    required int tableNumber,
  }) {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: tableNumber,
        items: state.items,
      ),
    );
  }

  ///add menu model
  void removeMenu() {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: state.items,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
        EditSaleCartState(
          remark: state.remark,
          tableNumber: state.tableNumber,
          items: updatedItems,
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
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: updatedItems,
      ),
    );
  }

  // Method to remove an item from the cart
  void clearOrderr() {
    emit(
      EditSaleCartState(
        remark: state.remark,
        tableNumber: state.tableNumber,
        items: [],
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
