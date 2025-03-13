import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

/**
   * widget to show each receive product with quantity,amount,
   */
Widget cartItemWidget({
  required CartItem cartItem,
  required BuildContext context,
  required Size screenSize,
  required Function() onEdit,
  required Function() onDelete,
  required bool ontapDisable,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      highlightColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          top: 8,
          left: MyPadding.normal,
          right: MyPadding.normal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${cartItem.name}",
                    style: TextStyle(
                      fontSize: FontSize.small - 1,
                    ),
                  ),
                  cartItem.is_gram
                      ? Text(
                          "${cartItem.qty}gram x ${cartItem.price} ",
                          style: TextStyle(
                            fontSize: FontSize.small - 1,
                          ),
                        )
                      : Text(
                          "${cartItem.qty} x ${cartItem.price} THB",
                          // "${cartItem.price}THB/${cartItem.qty} THB",
                          style: TextStyle(
                            fontSize: FontSize.small - 1,
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      //"${cartItem.totalPrice} THB",
                      "${NumberFormat('#,##0').format(cartItem.totalPrice)} THB",
                      style: TextStyle(
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ontapDisable ? Container() : SizedBox(width: 10),
            ontapDisable
                ? Container()
                : InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Icon(
                        CupertinoIcons.delete_solid,
                        size: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

Widget cartMenuWidget({
  required BuildContext context,
  required Size screenSize,
  required Function() onEdit,
  required Function() onDelete,
  required bool ontapDisable,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      highlightColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          top: 0,
          left: MyPadding.normal,
          right: MyPadding.normal,
        ),
        child: Column(
          children: [
            ///menu widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 20),
                ontapDisable
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: InkWell(
                          onTap: onDelete,
                          // onTap: () async {

                          // },
                          child: Icon(
                            CupertinoIcons.delete_solid,
                            size: 20,
                          ),
                        ),
                      ),
              ],
            ),

            ///spicy level widget
            SizedBox(height: 4),
          ],
        ),
      ),
    ),
  );
}
