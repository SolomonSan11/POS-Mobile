import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/product_detail_control.dart';
import 'package:golden_thailand/ui/widgets/table_number_dialog.dart';

///product row widget
Widget productRowWidget({
  required int index,
  required ProductModel product,
  required BuildContext context,
  required TextEditingController tableController,
  required bool isEditState,
}) {
  CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
  return InkWell(
    highlightColor: SScolor.primaryColor.withOpacity(0.3),
    onTap: () {
      if (isEditState) {
        showDialog(
          context: context,
          builder: (context) {
            return ProductWeightOrDetailControl(
              produt: product,
              isEditState: true,
            );
          },
        );
      } else {
        if (cartCubit.state.tableNumber == 0) {
          showDialog(
            context: context,
            builder: (context) {
              return TableNumberDialog(
                tableController: tableController,
                isBuffet: product.is_buffet == 1,
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return ProductWeightOrDetailControl(
                produt: product,
                isEditState: false,
              );
            },
          );
        }
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.product_number != ""
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${product.product_number}.",
                        style: TextStyle(
                          fontSize: FontSize.normal,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${product.name}",
                          style: TextStyle(
                            fontSize: FontSize.normal,
                          ),
                        ),
                      )
                    ],
                  )
                : Text(
                    //"${index == 0 ? 1 : index + 1}. ${product.name}",
                    " ${product.name}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
          ),
          Text(
            "${product.price} THB",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: FontSize.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
