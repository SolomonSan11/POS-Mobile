import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/quantity_dialog_control.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/weight_dialog_control.dart';
import 'package:golden_thailand/ui/widgets/table_number_dialog.dart';

///cart item list widget
Container cartItemListWidget({
  required Size screenSize,
  required CartState state,
  required BuildContext context,
  required TextEditingController tableController
}) {
  return Container(
    height: screenSize.height * 0.52,
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: MyPadding.normal),
            child: custamizableElevated(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return TableNumberDialog(
                      tableController: tableController,
                      isBuffet: false,
                      //cartCubit: cartCubit,
                    );
                  },
                );
              },
              child: Text(
                "Table no.  ${state.tableNumber}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ...state.items
              .map(
                (e) => cartItemWidget(
                  ontapDisable: false,
                  cartItem: e,
                  screenSize: screenSize,
                  context: context,
                  onEdit: () {
                    ///show cart item quantity control
                    if (e.is_gram) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CartItemWeightControlDialog(
                            screenSizeWidth: screenSize.width,
                            weightGram: e.qty,
                            cartItem: e,
                            isEditState: false,
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CartItemQtyDialogControl(
                            screenSizeWidth: screenSize.width,
                            quantity: e.qty,
                            cartItem: e,
                            isEditState: false,
                          );
                        },
                      );
                    }
                  },
                  onDelete: () {
                    context.read<CartCubit>().removeFromCart(item: e);
                  },
                ),
              )
              .toList(),
        ],
      ),
    ),
  );
}
