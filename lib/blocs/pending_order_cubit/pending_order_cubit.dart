import 'package:bloc/bloc.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

part 'pending_order_state.dart';

class PendingOrderCubit extends Cubit<PendingOrderState> {
  final SharedPref sharedPref;

  PendingOrderCubit({required this.sharedPref})
      : super(PendingOrderState(pendingOrderList: [])) {
    _loadPendingOrders();
  }

  bool checkTable({required int tableId, required int tableNumber}) {
    return state.pendingOrderList
        .any((e) => tableId == e.tableId && tableNumber == e.tableNumber);
  }

  // bool checkIsProductExisted(CartItem item) {
  //   return state.items.any(
  //     (p) => p.name == item.name,
  //   );
  // }

  // Load pending orders from SharedPreferences
  Future<void> _loadPendingOrders() async {
    List<PendingOrder> orders = await sharedPref.loadPendingOrders();
    emit(PendingOrderState(pendingOrderList: orders));
  }

  // Save pending orders to SharedPreferences
  Future<void> _savePendingOrders(List<PendingOrder> orders) async {
    await sharedPref.savePendingOrders(orders);
  }

  // Add a pending order and update the local storage
  Future<void> addPendingOrder({required PendingOrder pendingOrder}) async {
    if (!checkIsExisted(pendingOrder)) {
      List<PendingOrder> updatedItems = List.from(state.pendingOrderList)
        ..add(pendingOrder);

      // Save updated list to local storage
      await _savePendingOrders(updatedItems);

      emit(PendingOrderState(pendingOrderList: updatedItems));
    }
  }

  // Remove a pending order and update the local storage
  Future<void> removePendingOrder({required PendingOrder pendingOrder}) async {
    if (checkIsExisted(pendingOrder)) {
      List<PendingOrder> updatedItems = state.pendingOrderList
          .where((e) => e.orderUniqueId != pendingOrder.orderUniqueId)
          .toList();

      // Save updated list to local storage
      await _savePendingOrders(updatedItems);

      emit(PendingOrderState(pendingOrderList: updatedItems));
    }
  }

  // Check if the selected order already exists in the list
  bool checkIsExisted(PendingOrder item) {
    return state.pendingOrderList.any(
      (p) => p.orderUniqueId == item.orderUniqueId,
    );
  }

  // Clear all pending orders from the state and SharedPreferences
  Future<void> clearAllPendingOrders() async {
    // Clear local storage
    await sharedPref.clearPendingOrders();

    // Emit an empty list state
    emit(PendingOrderState(pendingOrderList: []));
  }

  // Add a pending order and update the local storage
  Future<void> updateCardItemOrPendingOrder({
    required PendingOrder pendingOrder,
    required List<CartItem> cartItem,
  }) async {
    state.pendingOrderList.forEach((e) async {
      if (e.orderUniqueId == pendingOrder.orderUniqueId) {

        e.items = cartItem;
        // List<PendingOrder> updatedItems = List.from(state.pendingOrderList)
        //   ..add(e.copyWith(items: cartItem));

        // Save updated list to local storage
        await _savePendingOrders(state.pendingOrderList);

        print("update pending order");
        cartItem.forEach((e) => print(e.name));

        emit(PendingOrderState(pendingOrderList: state.pendingOrderList));
      } else {
        print("is not exist");
      }
    });
    // if (!checkIsExisted(pendingOrder)) {

    // }else{
    //   print("not exist");
    // }
  }
}
